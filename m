Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B2D837CA0
	for <xfs@oss.sgi.com>; Tue, 30 Aug 2016 11:40:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0A5A3AC002
	for <xfs@oss.sgi.com>; Tue, 30 Aug 2016 09:40:00 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id H9DvLtjf8ZOJMhai (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 30 Aug 2016 09:39:58 -0700 (PDT)
Date: Tue, 30 Aug 2016 09:39:53 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: xfstests xfs fuzzers fail with DAX
Message-ID: <20160830163953.GA26710@birch.djwong.org>
References: <20160804024514.GA2906@xzhoul.usersys.redhat.com>
	<CAPcyv4g1CkMZoq+vHcyPZW3ME7Qr=6pW10BTxg2n+e+28+MFKA@mail.gmail.com>
	<20160830023727.GH22760@birch.djwong.org>
	<CAA9_cmfFMGQHTA_N5CGbXhdc=4qJsJbNJXu0WyUEJp7YguFo7Q@mail.gmail.com>
	<CAPcyv4hK9z7uqYEykk5Xq=+e6wGiai5wibGy7Xks9GzC--R9Dg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hK9z7uqYEykk5Xq=+e6wGiai5wibGy7Xks9GzC--R9Dg@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>

On Tue, Aug 30, 2016 at 09:25:45AM -0700, Dan Williams wrote:
> On Tue, Aug 30, 2016 at 7:53 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> > On Mon, Aug 29, 2016 at 7:37 PM, Darrick J. Wong
> > <darrick.wong@oracle.com> wrote:
> >> On Mon, Aug 29, 2016 at 06:50:05PM -0700, Dan Williams wrote:
> >>> [ Adding Darrick on the off chance that this triggers an "aha, of
> >>> course it does!" ]
> >>
> >> Aha!  Of course it does!!! :)
> >
> > Heh, thanks :).  And apologies to Dave for missing his earlier note
> > pointing out the delalloc failure, linux-nvdimm list ate the response.
> >
> >>
> >>> Darrick these corruption tests you added to xfstests last year all
> >>> fail the same way with DAX enabled.  They spew:
> >>>
> >>>     "pwrite64: Structure needs cleaning"
> >>>
> >>> ...reports that are cleaned up by running without "-o dax".
> >>
> >> I think this happens because in non-dax mode, the pwrite is a buffered
> >> write and so long as we can create a delalloc reservation, everything
> >> is ok and nothing fails.  Whereas for dax we have to allocate the
> >> blocks for the pwrite immediately, thereby triggering the cntbt
> >> verifier error.
> >>
> >> Proceeding from the assumption "DAX behaves a lot like DIO", all the
> >> tests that rely on buffered mode semantics are going to choke if DAX
> >> is turned on without them knowing about it.
> >>
> >>> Alternatively you could sit back and watch me try to figure it out,
> >>> that should be quite entertaining... as a start I'll try to pin down a
> >>> stack trace when the error is returned.
> >>
> >> As for how to fix this, probably the best option is to change line 98
> >> to 'pwrite -W -S 0x62...' and update the output to include the
> >> 'structure needs cleaning' message.
> >
> > I'll give it a shot.
> 
> So, that did not modulate the failure or the passing case.  However,
> using -d at line 122 makes the no-dax case fail the same as the dax
> case.
> 
> Would a change like this be acceptable in the interim while we figure
> out which tests are delalloc sensitive, or did I just invalidate the
> test?
> 
> diff --git a/tests/xfs/086 b/tests/xfs/086
> index 143915bafaa1..26607c7a4697 100755
> --- a/tests/xfs/086
> +++ b/tests/xfs/086
> @@ -96,7 +96,7 @@ _scratch_mount
> 
>  echo "+ modify files"
>  for x in `seq 1 64`; do
> -       $XFS_IO_PROG -f -c "pwrite -S 0x62 0 ${blksz}"
> "${TESTFILE}.${x}" >> $seqres.full
> +       $XFS_IO_PROG -f -c "pwrite -d -S 0x62 0 ${blksz}"
> "${TESTFILE}.${x}" >> $seqres.full
>  done
>  umount "${SCRATCH_MNT}"
> 
> @@ -119,7 +119,7 @@ echo "broken: ${broken}"
>  # Try appending again, now that we've fixed the fs
>  echo "+ modify files (2)"
>  for x in `seq 1 64`; do
> -       $XFS_IO_PROG -f -c "pwrite -S 0x62 ${blksz} ${blksz}"
> "${TESTFILE}.${x}" >> $seqres.fu
> +       $XFS_IO_PROG -f -c "pwrite -d -S 0x62 ${blksz} ${blksz}"
> "${TESTFILE}.${x}" >> $seqres
>  done
>  umount "${SCRATCH_MNT}"
> 
> diff --git a/tests/xfs/086.out b/tests/xfs/086.out
> index 6c053f42deea..e2ec84e6b90f 100644
> --- a/tests/xfs/086.out
> +++ b/tests/xfs/086.out
> @@ -16,5 +16,5 @@ broken: 1
>  + mount image
>  + chattr -R -i
>  + check files (2)
> -broken: 0
> +broken: 1

There shouldn't be any brokenness left over at this point in the test.

--D

>  + check fs (2)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

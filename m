Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BFFC37CA4
	for <xfs@oss.sgi.com>; Tue, 30 Aug 2016 09:53:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8F9BF304039
	for <xfs@oss.sgi.com>; Tue, 30 Aug 2016 07:53:45 -0700 (PDT)
Received: from mail-qk0-f180.google.com (mail-qk0-f180.google.com
	[209.85.220.180]) by cuda.sgi.com with ESMTP id
	WyBPClcvTGilrcQV (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 30 Aug 2016 07:53:43 -0700 (PDT)
Received: by mail-qk0-f180.google.com with SMTP id l2so20858013qkf.3
	for <xfs@oss.sgi.com>; Tue, 30 Aug 2016 07:53:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160830023727.GH22760@birch.djwong.org>
References: <20160804024514.GA2906@xzhoul.usersys.redhat.com>
	<CAPcyv4g1CkMZoq+vHcyPZW3ME7Qr=6pW10BTxg2n+e+28+MFKA@mail.gmail.com>
	<20160830023727.GH22760@birch.djwong.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 30 Aug 2016 07:53:41 -0700
Message-ID: <CAA9_cmfFMGQHTA_N5CGbXhdc=4qJsJbNJXu0WyUEJp7YguFo7Q@mail.gmail.com>
Subject: Re: xfstests xfs fuzzers fail with DAX
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-nvdimm <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>

On Mon, Aug 29, 2016 at 7:37 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Mon, Aug 29, 2016 at 06:50:05PM -0700, Dan Williams wrote:
>> [ Adding Darrick on the off chance that this triggers an "aha, of
>> course it does!" ]
>
> Aha!  Of course it does!!! :)

Heh, thanks :).  And apologies to Dave for missing his earlier note
pointing out the delalloc failure, linux-nvdimm list ate the response.

>
>> Darrick these corruption tests you added to xfstests last year all
>> fail the same way with DAX enabled.  They spew:
>>
>>     "pwrite64: Structure needs cleaning"
>>
>> ...reports that are cleaned up by running without "-o dax".
>
> I think this happens because in non-dax mode, the pwrite is a buffered
> write and so long as we can create a delalloc reservation, everything
> is ok and nothing fails.  Whereas for dax we have to allocate the
> blocks for the pwrite immediately, thereby triggering the cntbt
> verifier error.
>
> Proceeding from the assumption "DAX behaves a lot like DIO", all the
> tests that rely on buffered mode semantics are going to choke if DAX
> is turned on without them knowing about it.
>
>> Alternatively you could sit back and watch me try to figure it out,
>> that should be quite entertaining... as a start I'll try to pin down a
>> stack trace when the error is returned.
>
> As for how to fix this, probably the best option is to change line 98
> to 'pwrite -W -S 0x62...' and update the output to include the
> 'structure needs cleaning' message.

I'll give it a shot.

> Or get rid of the mount option and require explicitly turning on DAX
> on a per-inode basis, which I think is where Dave is already going.

Yes, I think we can't run away from the dax mount option fast enough.
The semantics are different, so an application / administrator needs
to explicitly opt-in to DAX semantics per-inode otherwise we are
guaranteed to cause surprises.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

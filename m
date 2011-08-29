Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7TGaOND081052 for <xfs@oss.sgi.com>; Mon, 29 Aug 2011 11:36:24 -0500
Received: from nm4-vm0.bullet.mail.sg1.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 7C926122525
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2011 09:36:22 -0700 (PDT)
Received: from nm4-vm0.bullet.mail.sg1.yahoo.com
	(nm4-vm0.bullet.mail.sg1.yahoo.com [115.178.12.244]) by
	cuda.sgi.com with SMTP id PN2BVAFIAqOJhjYU for
	<xfs@oss.sgi.com>; Mon, 29 Aug 2011 09:36:22 -0700 (PDT)
Message-ID: <1314635781.16065.YahooMailClassic@web77703.mail.sg1.yahoo.com>
Date: Tue, 30 Aug 2011 00:36:21 +0800 (SGT)
From: Gim Leong Chin <chingimleong@yahoo.com.sg>
Subject: Re: xfsrestore Does Only Only Partial Restore
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs@oss.sgi.com

Hi Bill,

Right now the log file is already over 500 MB and growing.=A0 Even after co=
mpression I do not think I can mail it as an attachment.

Is there any other way that I can send you the log files?


GL

--- On Mon, 29/8/11, Bill Kendall <wkendall@sgi.com> wrote:

> From: Bill Kendall <wkendall@sgi.com>
> Subject: Re: xfsrestore Does Only Only Partial Restore
> To: "Gim Leong Chin" <chingimleong@yahoo.com.sg>
> Cc: xfs@oss.sgi.com
> Date: Monday, 29 August, 2011, 10:11 PM
> Gim Leong Chin wrote:
> > Hi,
> > =

> > This is the very first time I tried doing a xfsrestore
> of a back up and I hit some serious trouble.
> > =

> > I had openSUSE 11.1 (kernel 2.6.27) on my Acer
> notebook.=A0 I did a xfsdump of /home to a WD My Passport
> external USB hard drive with XFS on it.
> > =

> > I installed openSUSE 11.4 (kernel 2.6.37), then tried
> to do xfsrestore from the WD USB drive.=A0 The dump file
> is 121 GB.
> > =

> > I tried two times on two different days, but each time
> the xfsrestore would stop writing at the exact same point,
> 49 GB and say success at the end.
> > =

> > I then copied the dump file to one hard drive on my
> desk top, and did a dump to another hard drive, to
> /tmp/mnt3.=A0 I get back identical messages:
> > =

> =

> ...
> =

> > 9>xfsrestore: attempt to read 1008286921 bytes
> failed: end of recorded data
> =

> xfsdump breaks a file's data into "extents" that are a max
> size of 16 MB.
> The fact that this is trying to read almost 1 GB here
> indicates that
> the extend header is corrupt.
> =

> ...
> =

> >=A0=A0=A0xfsrestore: content.c:7510:
> restore_extent_group: Assertion `ehdr.eh_type =3D=3D 4' failed.
> =

> As Dave said, this also indicates a corrupt extent header.
> =

> I'd recommend adding "-v 5" to your xfsrestore command line
> and redirecting the
> (very verbose) output to a file, and send that compressed
> output to me or the
> list. It'd be best to do this with more than one of your
> dumps so we can see
> if there's a pattern to where the corruption occurs.
> =

> Bill
> =

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

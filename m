Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C64507F3F
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 09:58:01 -0500 (CDT)
Received: from dhcp-128-162-232-117.americas.sgi.com
	(dhcp-128-162-232-117.americas.sgi.com [128.162.232.117])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 946908F8037
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 07:57:58 -0700 (PDT)
Message-ID: <53E8D9F6.7080704@sgi.com>
Date: Mon, 11 Aug 2014 09:57:58 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: Subject : Happened again,
	20140811 -- Got "Internal error XFS_WANT_CORRUPTED_GOTO".
	Filesystem needs reformatting to correct issue.
References: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>
	<alpine.LSU.2.11.1408111559280.2447@minas-tirith.valinor>
In-Reply-To: <alpine.LSU.2.11.1408111559280.2447@minas-tirith.valinor>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 08/11/14 09:23, Carlos E. R. wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA256
>
>
>
> El 2014-07-02 a las 11:57 +0200, Carlos E. R. escribi=F3:
>
>> I got this error:
>
> Happened again, I'm on middle of recovery procedures, and using my
> laptop to post.
>
>
> The system did not "die", I could still use xterms owned by root. So I
> tried to use xfs_metadump before rebooting, but it refused, said that
> the partition was mounted (and I know from previous times that umounting
> fails or locks the machine). It also said that it could not intialize
> the XFS library.
>
> So I logged out, and issued "reboot" on tty1 as root. No go, it got
> stuck somewhere, and I had to hit the physical reset button on the
> machine. I have not looked at the logs yet.
>
> I am now running the machine off a live usb stick (13.1 XFCE rescue
> system) to avoid the automatics to fsck the home partition, and I
> already obtained a xfs_metadump of it.
>
> I post this in case you have some suggestion before I nuke the partition
> (rsync, reformat, etc). It shold take some hours.
>
> - -- Cheers
> Carlos E. R.

Where in the filesystem did the XFS_WANT_CORRUPTED_GOTO happen?

I am interested in the metadata dump.

Also, some one hit back to back duplicate block allocation =

XFS_WANT_CORRUPTED_GOTO bugs, you may want to do a metadata dump before =

and after the xfs_repair in case you hit it again soon.

If this is a duplicate block allocation, some user blocks will have =

overwritten the metadata.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

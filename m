Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAMIlRJG163851 for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 12:47:27 -0600
Received: from mail-yx0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B2FE0257819
	for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 10:47:25 -0800 (PST)
Received: from mail-yx0-f181.google.com (mail-yx0-f181.google.com
	[209.85.213.181]) by cuda.sgi.com with ESMTP id
	AytfponE4H6zw5vl for <xfs@oss.sgi.com>;
	Tue, 22 Nov 2011 10:47:25 -0800 (PST)
Received: by yenm3 with SMTP id m3so678629yen.26
	for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 10:47:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111122014114.GJ2386@dastard>
References: <CAF3hT9B8-ou-4RhfCkfFWTwwB_tb7nWSP-5pgP3G6oTE+1gAvA@mail.gmail.com>
	<CAF3hT9AurrVi7xosauVmhQcsbqJgLsxkNYm6dWDNCpB+GR69=w@mail.gmail.com>
	<20111122014114.GJ2386@dastard>
Date: Tue, 22 Nov 2011 10:47:24 -0800
Message-ID: <CAF3hT9Cu+56WJqzHVu+fMgquddwoMsfW-WC8CvRRBtC4PA3uHw@mail.gmail.com>
Subject: Re: EFSCORRUPTED on mount?
From: Gregory Farnum <gregory.farnum@dreamhost.com>
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
To: xfs@oss.sgi.com
Cc: sandeen@sandeen.net

On Mon, Nov 21, 2011 at 5:41 PM, Dave Chinner <david@fromorbit.com> wrote:
> In other words, your admin basically told the system to shutdown
> without syncing the data or running shutdown scripts that sync data.
> i.e. it forces an immediate reboot while the system is still active,
> causing an unclean shutdown and guaranteed data loss.
And he's been yelled at appropriately. ;) But the data loss actually
isn't a problem for us here as long as the filesystem isn't corrupted.

>> But I've been assured this shouldn't have been able to
>> corrupt the filesystem, so troubleshooting continues.
>
> That depends entirely on your hardware. Are you running with
> barriers enabled? =A0If you don't have barriers active, then metadata
> corruption is entirely possible in this scenarion, especially if the
> hardware does a drive reset or power cycle during the reboot
> procedure. Even with barriers, there are RAID controllers that
> enable back end drive caches and they fail to get flushed and hence
> can cause corruption on unclean shutdowns.
Barriers on (at least, nobody turned them off); the RAID card is
battery-backed; here are megacli dumps:
http://pastebin.com/yTskgzWG
http://pastebin.com/ekhczycy

Sorry if I seem to eager to assume it's an xfs bug but Ceph is a magic
machine for taking stable filesystems and making them cry. :/


On Tue, Nov 22, 2011 at 7:06 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
> Others have had good comments but also:
>
>> 2011-11-17 16:00:37.294876 7f83f3eef720 filestore(/mnt/osd.17)
>> truncate meta/pginfo_12.7c8/0 size 0
>> 2011-11-17 16:00:37.483407 7f83f3eef720 filestore(/mnt/osd.17)
>> truncate meta/pginfo_12.7c8/0 size 0 =3D -117
>> 2011-11-17 16:00:37.483476 7f83f3eef720 filestore(/mnt/osd.17) =A0error
>> error 117: Structure needs cleaning not handled
>
> was there anything in dmesg/system logs right at this point? =A0XFS should
> have said something about this original error.
Whoops. The following is a sample of what was in dmesg and kern.log
after that point but before I did anything else (it repeated a lot but
there weren't any other lines of output):
xfs/xfs_buf.c.  Return address =3D 0xffffffff811c2aa8
[56459.526220] XFS (sdg1): xfs_log_force: error 5 returned.
[56489.544153] XFS (sdg1): xfs_log_force: error 5 returned.
[56519.562087] XFS (sdg1): xfs_log_force: error 5 returned.
[56549.580021] XFS (sdg1): xfs_log_force: error 5 returned.
[56579.597956] XFS (sdg1): xfs_log_force: error 5 returned.
[56609.615889] XFS (sdg1): xfs_log_force: error 5 returned.
[56613.036430] XFS (sdg1): xfs_log_force: error 5 returned.
[56613.041731] XFS (sdg1): xfs_do_force_shutdown(0x1) called from line
1037 of file fs/xfs/xfs_buf.c.  Return address =3D 0xffffffff811c2aa8
[56619.430497] XFS (sdg1): xfs_log_force: error 5 returned.
[56619.435796] XFS (sdg1): xfs_do_force_shutdown(0x1) called from line
1037 of file fs/xfs/xfs_buf.c.  Return address =3D 0xffffffff811c2aa8

Thanks!
-Greg

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0PCuU7D125189 for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 06:56:30 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6BDD91BAB57E
	for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 04:55:47 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id vMpjrihGOZ4AEcjZ for
	<xfs@oss.sgi.com>; Sun, 25 Jan 2009 04:55:47 -0800 (PST)
Date: Sun, 25 Jan 2009 07:55:46 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Switching from (deprecated) IDE driver -> SATA (PATA support)
	(found solution)
In-Reply-To: <alpine.DEB.1.10.0901250740360.11258@p34.internal.lan>
Message-ID: <alpine.DEB.1.10.0901250752020.11258@p34.internal.lan>
References: <alpine.DEB.1.10.0901250553430.2441@p34.internal.lan>
	<20090125110742.4ba54c0b@lxorguk.ukuu.org.uk>
	<alpine.DEB.1.10.0901250705300.6888@p34.internal.lan>
	<alpine.DEB.1.10.0901250715030.10379@p34.internal.lan>
	<alpine.DEB.1.10.0901250726530.10805@p34.internal.lan>
	<alpine.DEB.1.10.0901250740360.11258@p34.internal.lan>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com



On Sun, 25 Jan 2009, Justin Piszcz wrote:

>
>
> On Sun, 25 Jan 2009, Justin Piszcz wrote:
>
>> 
>> 
>> On Sun, 25 Jan 2009, Justin Piszcz wrote:
>> 
>>> 
>>> 
>>> On Sun, 25 Jan 2009, Justin Piszcz wrote:
>>> 
>>>> 
>>>> 
>>>> On Sun, 25 Jan 2009, Alan Cox wrote:

        root=<root-device>
               This specifies the device that should be mounted  as  root.   It
               may  be  specified as a global option.  If the special name cur-
               rent is used, the root device is set to the device on which  the
               root  file  system  is  currently  mounted. If the root has been
               changed with  -r , the respective device is used. If  the  vari-
               able `root' is omitted, the root device setting contained in the
               kernel image is used.  (And that is set at  compile  time  using
               the  ROOT_DEV  variable in the kernel Makefile, and can later be
               changed with the rdev(8) program.)

Change root= to root=current && lilo && reboot, this works as well, note I did
have the proper UUIDs set in /etc/fstab before doing this.

Trying without changing /etc/fstab, back to old entries:
/dev/hda2     /               xfs     noatime         0       1
/dev/hda1      none            swap    sw              0       0
#UUID=77ae4251-631f-4656-a365-c5723f5c5da8      /               xfs     noatime         0       1
#UUID=2ef862e1-cf78-4065-a205-d1784716d633      none            swap    sw              0       0

(which are wrong)

p254:~# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sdd2              73G  2.2G   71G   3% /
p254:~# df -h

But using current!

p254:~# grep current /etc/lilo.conf
# case it installs in the MBR, and will overwrite the current MBR.
root=current
         root=current
p254:~#

p254:~# reboot

Does it come back?

$ uptime
  07:55:16 up 0 min,  1 user,  load average: 0.71, 0.20, 0.07

Yes it does, so the work-around is to use root=current, fix up your /etc/fstab
and other files after.

Justin.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

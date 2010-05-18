Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4INTeop083310 for <xfs@oss.sgi.com>; Tue, 18 May 2010 18:29:41 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5A18112998F5
	for <xfs@oss.sgi.com>; Tue, 18 May 2010 16:33:01 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id AlYuHaxoH556MLN5
	for <xfs@oss.sgi.com>; Tue, 18 May 2010 16:33:01 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 2E8A76C2B0
	for <xfs@oss.sgi.com>; Tue, 18 May 2010 18:31:56 -0500 (CDT)
Message-ID: <4BF3241C.5080001@hardwarefreak.com>
Date: Tue, 18 May 2010 18:34:52 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: mounting hixfs (Hitachi "tuned" XFS) on 2.6 kernel
References: <AANLkTikek9K8-BqNgee_tXz72beHpWEUl41YtDPrD-3P@mail.gmail.com>	<4BF1EC44.7070803@hardwarefreak.com>	<AANLkTin_WoxWP3JXHvflVVP_2fGzgbSVfpPW1KGiyd1z@mail.gmail.com>	<4BF219A6.4010900@hardwarefreak.com>
	<AANLkTim93-4YueMBizXKLGRFka2vwqzJzDx5_P5gs0bl@mail.gmail.com>
In-Reply-To: <AANLkTim93-4YueMBizXKLGRFka2vwqzJzDx5_P5gs0bl@mail.gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

big beer put forth on 5/18/2010 10:19 AM:

> It's called a eNAS, but it's really just 2 linux 2.4 blades (debian
> woody), with failsafe (think heartbeat), LVM, custom XFS, samba, nfs,
> and a pile of sudo available scripts that are 700 and a web based gui
> to manage it.
> 
> I though about moving it via another FS on the NAS and then connecting
> it to my target migration host also. The only exposed connections on
> the hardware are ethernet, and it's integrated in the storage
> subsystem. I'd have to call a tech  to even come take it out. So I'm
> limited to something that is fiber attached to the sub-system, ok
> that's fine, just means no USB disk or the like. The real problem is
> that since I don't have root there is no way to create or mount any
> other devices that contain another FS. The restrictive GUI/scripts
> automatically creates and mounts FS's with their modified XFS version,
> and there are no options to do otherwise.
> 
> I'm playing it "safe" by taking a block level copy of the luns that
> are exposed to this thing, and then presenting the copy over to my
> target host. I'm not brave enough to totally trash live data. I'm
> going to give some of the suggestions a go with a fresh copy of the
> data and see what comes of it.

Ahh, ok.  We're not talking about some cheap single box NAS appliance here
with 4-10 local disks, but a blade "appliance" which connects via FC to SAN
LUNs on back end arrays.  And lemme guess, the sales guy pitched
"flexibility" as a main selling point.  A poor rich man's NetApp so to
speak.  Sounds like a decent setup.  Except for the fact that protocols
change, along with Samba features.  It is flexible, except in the way you
currently need it to be.

Agreed, you're not taking chances.  I didn't comprehend previously what
exactly you were doing.  Thanks for the explanation.  Snapshotting the LUNs
is obviously a very safe method.

> Of course the 1st thing I did was call Hitachi support and ask them
> what the deal is, dropping words like "GPL" and "license bound to
> distribute", but to no avail. Of course I'm dealing with low level
> support people that more than likely didn't work for the big H when
> this thing was built. I've escalated through the channels I have
> available to me.

Well, they've done what they can to lock you into their NAS solution...

Is the actual blade hardware that terribly slow?  If not, do they offer a
new "firmware" load for that blade bringing it up to a Hitachi proprietary
2.6.x kernel with a much newer Samba/NFS/etc?  I know you'd rather whip up a
solution yourself with standard FOSS stuff, but maybe this would be a viable
option for now if they offer it.  Given the blade's age they probably don't
offer anything to upgrade it.  Can't hurt to ask.

> We'll see what comes of it.

Any chance you can build a system from an old Woody installation set that
closely matches what's on the NAS?  Then copy over their hacked proprietary
HIXFS modules, mount the HIXFS LUNs and copy everything to an EXT2 formatted
LUN?  If you can get this far you're home free.  I guess the hard part will
be getting access to those modules and libraries since you can't login as
root...

-- 
Stan


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

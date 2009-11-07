Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nA7BSI6t026422 for <xfs@oss.sgi.com>; Sat, 7 Nov 2009 05:28:20 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 65366182E5AC
	for <xfs@oss.sgi.com>; Sat,  7 Nov 2009 03:28:32 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id Lue1ikbs5zuqFbbH for
	<xfs@oss.sgi.com>; Sat, 07 Nov 2009 03:28:32 -0800 (PST)
Date: Sat, 7 Nov 2009 06:28:32 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: kernel crash with damaged XFS
In-Reply-To: <200911070837.21003@zmi.at>
Message-ID: <alpine.DEB.2.00.0911070627570.4559@p34.internal.lan>
References: <200911061017.12200@zmi.at>
	<88ED0857-A754-4E3C-BA26-FC5EE85D7394@sandeen.net>
	<200911070837.21003@zmi.at>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-1463747160-1703923134-1257593312=:4559"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-1703923134-1257593312=:4559
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sat, 7 Nov 2009, Michael Monnerie wrote:

> On Freitag 06 November 2009 Eric Sandeen wrote:
>>> I had that during the last days on my system. It kept on running =A0
>>> despite
>>> this error. I xfs_repair'ed the fs again and now it's working.
>>> This is the same server I talked about with Eric last time, where
>>> he improved xfs_repair and that repaired my fs. I had to run
>>> xfs_repair several times again until all errors were solved,
>>> and now nothing is reported anymore.
>>> The server had no crash or whatever since the last repair, so I
>>> wonder where these corruptions come from.
>>>
>>> Nov =A02 00:01:12 orion.i.zmi.at kernel: Filesystem "dm-0": corrupt =A0
>>> inode 3858839593 ((a)extents =3D 7). =A0Unmount and run xfs_repair.
>>
>> Just FWIW this is not a crash, it is XFS properly handling
>> corrruption =A0 it encountered. =A0The corruption could be due to a bug
>> in XFS or other code, or a hardware problem. =A0Does repair fix it this
>> time?
>
> Yes Eric, that's what I wrote but I see it can be misinterpreted as
> belonging to the old case. I meant the actual problem when saying:
>
> I had to run xfs_repair several times again until all errors were
> solved, and now nothing is reported anymore. The server had no crash or
> whatever since the last repair, so I wonder where these corruptions come
> from.
>
> Seems to be time to make a memory check. I have no other idea where the
> problem could come from.
>
> mfg zmi
> --=20
> // Michael Monnerie, Ing.BSc    -----      http://it-management.at
> // Tel: 0660 / 415 65 31                      .network.your.ideas.
> // PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
> // Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
> // Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

memtest is a good idea
also run a short & long test on each hdd and show smartctl -a of each=20
device to see if any may be failing

---1463747160-1703923134-1257593312=:4559
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

---1463747160-1703923134-1257593312=:4559--

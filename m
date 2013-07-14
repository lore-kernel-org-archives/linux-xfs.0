Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 121537F37
	for <xfs@oss.sgi.com>; Sun, 14 Jul 2013 17:42:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 82AD4AC001
	for <xfs@oss.sgi.com>; Sun, 14 Jul 2013 15:42:20 -0700 (PDT)
Received: from mail-oa0-f53.google.com (mail-oa0-f53.google.com
	[209.85.219.53]) by cuda.sgi.com with ESMTP id 3c22GloXBk6kzIy7
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 14 Jul 2013 15:42:16 -0700 (PDT)
Received: by mail-oa0-f53.google.com with SMTP id k14so14817710oag.40
	for <xfs@oss.sgi.com>; Sun, 14 Jul 2013 15:42:15 -0700 (PDT)
Subject: Re: specify agsize?
Mime-Version: 1.0 (Apple Message framework v1085)
From: aurfalien <aurfalien@gmail.com>
In-Reply-To: <51E32144.3020109@hardwarefreak.com>
Date: Sun, 14 Jul 2013 15:42:11 -0700
Message-Id: <2869A4A3-909A-486D-90A2-C1B04317EA40@gmail.com>
References: <6A14EB72-A699-47AF-937D-D6DA1CF12ACB@gmail.com>
	<51E2092D.7090409@sandeen.net>
	<9AB8D1D3-29D7-4C43-A624-37024CA4EFD9@gmail.com>
	<51E2CE83.9080003@sandeen.net> <51E32144.3020109@hardwarefreak.com>
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
To: stan@hardwarefreak.com
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com


On Jul 14, 2013, at 3:08 PM, Stan Hoeppner wrote:

> On 7/14/2013 11:14 AM, Eric Sandeen wrote:
> 
>> http://wikihelp.autodesk.com/Creative_Finishing/enu/2012/Help/05_Installation_Guides/Installation_and_Configuration_Guide_for_Linux_Workstations/0118-Advanced118/0194-Manually194/0199-Creating199
>> 
>> I guess?
>> 
>> That's quite a procedure!  And I have to say, a slightly strange one at first glance.
> 
> Agreed.
> 
>> It'd be nice if they said what they were trying to accomplish rather than just giving you a long recipe.
> 
> Again.
> 
>> In the end, I think they are trying to create 128AGs and maybe work around some mkfs corner case or other.
> 
> Or it's just as likely they are laying out these image frames in a
> specific manner across 128 directories, assuming 128 AGs exist, to
> achieve some specific "on disk" organization of the files.  It's simply
> not possible to know without more information.
> 
> Interestingly, on a 14+2 RAID6 array of 7.2K drives, normally 128 AGs
> will decrease parallel performance due to a huge increase in head seek
> latency.  Thus I'd assume this isn't a parallel workload.  Either that
> or Autodesk doesn't know XFS as well as they believe.

Now hold on a minute here Stan.

While I don't really like Autodesk as they pretty much atrophy software.  The fact is that they, the finishing suite division, know XFS and realtime 2K performance is realized all day long as long as one follows there guidelines.

After all, SGI developed XFS as well as visual computing stations and back in the day, you had SGIs running Flame vs today which is Linux.

Flame is a visual computing app after all.  Albeit with a front end or GUI tuned to artists but still.

My initial post on this was to try and understand if there mobs make sense to the general XFS community and wether I could benefit from them in applying those mods to general purpose storage.

- aurf
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

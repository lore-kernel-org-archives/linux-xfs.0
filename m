Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 252B57F37
	for <xfs@oss.sgi.com>; Sun, 14 Jul 2013 17:08:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B291EAC001
	for <xfs@oss.sgi.com>; Sun, 14 Jul 2013 15:08:06 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id DXGImhP2YLcxGUDD
	for <xfs@oss.sgi.com>; Sun, 14 Jul 2013 15:08:02 -0700 (PDT)
Message-ID: <51E32144.3020109@hardwarefreak.com>
Date: Sun, 14 Jul 2013 17:08:04 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: specify agsize?
References: <6A14EB72-A699-47AF-937D-D6DA1CF12ACB@gmail.com>
	<51E2092D.7090409@sandeen.net>
	<9AB8D1D3-29D7-4C43-A624-37024CA4EFD9@gmail.com>
	<51E2CE83.9080003@sandeen.net>
In-Reply-To: <51E2CE83.9080003@sandeen.net>
Reply-To: stan@hardwarefreak.com
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com, aurfalien <aurfalien@gmail.com>

On 7/14/2013 11:14 AM, Eric Sandeen wrote:

> http://wikihelp.autodesk.com/Creative_Finishing/enu/2012/Help/05_Installation_Guides/Installation_and_Configuration_Guide_for_Linux_Workstations/0118-Advanced118/0194-Manually194/0199-Creating199
> 
> I guess?
> 
> That's quite a procedure!  And I have to say, a slightly strange one at first glance.

Agreed.

> It'd be nice if they said what they were trying to accomplish rather than just giving you a long recipe.

Again.

> In the end, I think they are trying to create 128AGs and maybe work around some mkfs corner case or other.

Or it's just as likely they are laying out these image frames in a
specific manner across 128 directories, assuming 128 AGs exist, to
achieve some specific "on disk" organization of the files.  It's simply
not possible to know without more information.

Interestingly, on a 14+2 RAID6 array of 7.2K drives, normally 128 AGs
will decrease parallel performance due to a huge increase in head seek
latency.  Thus I'd assume this isn't a parallel workload.  Either that
or Autodesk doesn't know XFS as well as they believe.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

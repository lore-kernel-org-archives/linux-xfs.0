Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BE2A97CBF
	for <xfs@oss.sgi.com>; Tue, 20 Oct 2015 14:41:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9BA4B304059
	for <xfs@oss.sgi.com>; Tue, 20 Oct 2015 12:41:33 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id D7SpAiocXjrDKlTB for <xfs@oss.sgi.com>;
	Tue, 20 Oct 2015 12:41:30 -0700 (PDT)
From: Eric Sandeen <sandeen@sandeen.net>
Mime-Version: 1.0 (1.0)
Subject: Re: du result is smaller than xfs_quota report
Date: Tue, 20 Oct 2015 14:35:39 -0500
Message-Id: <0952A0E9-F360-46CE-BE7A-1B8473700F08@sandeen.net>
References: <tencent_7585C3B40C484DE23B248E82@qq.com>
In-Reply-To: <tencent_7585C3B40C484DE23B248E82@qq.com>
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
To: YeYin <eyniy@qq.com>
Cc: xfs <xfs@oss.sgi.com>


> On Oct 20, 2015, at 4:09 AM, YeYin <eyniy@qq.com> wrote:
> 
> Hi, all,
> I encountered some problems when I used XFS with project quota:
> 
> # cat /etc/projid 
> docker-15091421396426:65061
> docker-15092311522409:26286
> docker-15101215637294:14162
> 
> # cat /etc/projects 
> 65061:/data/docker-volumes/docker-15091421396426
> 26286:/data/docker-volumes/docker-15092311522409
> 14162:/data/docker-volumes/docker-15101215637294
> 
> # xfs_quota -xc 'report -h' /data          
> Project quota on /data (/dev/sda4)
>                         Blocks              
> Project ID   Used   Soft   Hard Warn/Grace   
> ---------- --------------------------------- 
> docker-15091421396426   1.0G      0   100G  00 [------]
> docker-15092311522409 371.5G      0   700G  00 [------]
> docker-15101215637294 920.8M      0   400G  00 [------]
> 
> # du -sh /data/docker-volumes/docker-15092311522409 
> 200G    /data/docker-volumes/docker-15092311522409
> 
> As we can see,  du's result(200G) is smaller than xfs_quota report.
> 
Is anything mounted under that directory hierarchy, and hiding files from du's view?

Eric
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4IAxaj9047915 for <xfs@oss.sgi.com>; Tue, 18 May 2010 05:59:37 -0500
Received: from mx2.isti.cnr.it (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9727B1096E9F
	for <xfs@oss.sgi.com>; Tue, 18 May 2010 04:02:54 -0700 (PDT)
Received: from mx2.isti.cnr.it (mx2.isti.cnr.it [194.119.192.4]) by
	cuda.sgi.com with ESMTP id keqGEc0EXigriZ8O for
	<xfs@oss.sgi.com>; Tue, 18 May 2010 04:02:54 -0700 (PDT)
Received: from conversionlocal.isti.cnr.it by mx.isti.cnr.it (PMDF V6.5 #31825)
	id <01NN9GNEFGPCE7Y8WH@mx.isti.cnr.it> for xfs@oss.sgi.com; Tue,
	18 May 2010 13:01:04 +0100
Date: Tue, 18 May 2010 13:01:47 +0200
From: Default User <default_user@email.it>
Subject: Re: xfs_repair 3.1.1 doesnt repair broken filesystem
In-reply-to: <201005180953.51892@zmi.at>
Message-id: <4BF2739B.6000509@email.it>
MIME-version: 1.0
References: <201005180953.51892@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On 05/18/2010 09:53 AM, Michael Monnerie wrote:
> I do a repair on a broken filesystem, which reports no problems. Then I
> mount and "ls -l", and you can easily see all those broken entries,
> which should be directories. They are not repaired. What could I do?
>    

I think you have created the filesystem with -o inode64 and now you are 
remounting it without -o inode64.
After you created one file or directory with the inode64 option you NEED 
to always specify inode64 option at subsequent mounts or you won't be 
able to access such files/directories.
(Not sure if forgetting to use the option can even cause data corruption 
upon write. Might inode32 writes overwrite the inaccessible inode64 
files/dirs? XFS developers might know this.)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

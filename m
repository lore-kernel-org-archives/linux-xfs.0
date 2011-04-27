Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3RKF2CK230032
	for <linux-xfs@oss.sgi.com>; Wed, 27 Apr 2011 15:15:03 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3A9F111A96E5
	for <linux-xfs@oss.sgi.com>; Wed, 27 Apr 2011 13:18:34 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id fqLz6UQhKYOAl6FE for <linux-xfs@oss.sgi.com>;
	Wed, 27 Apr 2011 13:18:34 -0700 (PDT)
Message-ID: <4DB87A19.30306@sandeen.net>
Date: Wed, 27 Apr 2011 15:18:33 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: 2 question about XFS fragmentation and _fsr: SPLITTED Q1:sparse
	files
References: <DFA094D472104424BEA7AA9060DE0D6F@myXP>	<20110411214238.GE21395@dastard>
	<45DD2814B0C84BF3AFD76721A0178E50@myXP>
In-Reply-To: <45DD2814B0C84BF3AFD76721A0178E50@myXP>
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
To: Janos Haar <janos.haar@netcenter.hu>
Cc: linux-xfs@oss.sgi.com

On 4/26/11 4:51 PM, Janos Haar wrote:

<snip>

>>> In the result, actually we have >6TB images on the 3TB disk, wich is
>>> 97.9% fragmented.
>>
>> How are you determining that figure?
> 
> [root@UNISTORE admin]# cat xfs_get_frat_ratio
> echo loop0
> xfs_db -c frag -r /dev/loop0
> [root@UNISTORE admin]# ./xfs_get_frat_ratio
> loop0
> actual 7650952, ideal 752501, fragmentation factor 90.16%

so you had 7650952 extents on the fs, ideally you'd have 752501, or so xfs_db says...

Another way of looking at this is that you have about 10 extents per file on average.

Depending on the size of the files, this may be perfectly fine.
Is, for example, a 10G file in ten 1G extents really a problem?

I doubt that fragmentation is your performance problem here.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

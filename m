Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2QGiOmP177143 for <xfs@oss.sgi.com>; Thu, 26 Mar 2009 11:44:34 -0500
Received: from nuka.cjx.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AD55C13CF292
	for <xfs@oss.sgi.com>; Thu, 26 Mar 2009 09:43:59 -0700 (PDT)
Received: from nuka.cjx.com (37.233.187.81.in-addr.arpa [81.187.233.37]) by
	cuda.sgi.com with ESMTP id n2W2TeVTsM3Cwl2f for
	<xfs@oss.sgi.com>; Thu, 26 Mar 2009 09:43:59 -0700 (PDT)
Received: from chris-allens-imac-g5.local (mac.cjx.com [10.0.1.8])
	by nuka.cjx.com (8.14.3/8.14.3/Debian-4) with ESMTP id n2QGhUPf012956
	for <xfs@oss.sgi.com>; Thu, 26 Mar 2009 16:43:31 GMT
Message-ID: <49CBB0B5.7040107@cjx.com>
Date: Thu, 26 Mar 2009 16:43:33 +0000
From: Chris Allen <chris@cjx.com>
MIME-Version: 1.0
Subject: Re: accidentally deleted very large file (3.5TB) but still available
	through loop device
References: <49CBA221.2090701@cjx.com> <49CBA80A.8010500@sandeen.net>
In-Reply-To: <49CBA80A.8010500@sandeen.net>
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
To: xfs@oss.sgi.com



Eric Sandeen wrote:
> Chris Allen wrote:
>   
>> Hi,
>>
>> In a nutshell, I did the following:
>>
>> 1. dd if=some_filesystem_dump of=some_file (where some_file resides on
>> an XFS filesystem and is 3.5TB large)
>>
>> 2. losetup /dev/loop0 some_file
>>
>> 3. mount /dev/loop0 /recovered
>>
>> [.... i can now access my recovered filesystem through /recovered ...]
>>
>> 4. rm some_file (remotely via an nfs export) (oops!)
>>
>> So, I just removed my 3.5TB file even though it is attached to the loop
>> device and mounted (XFS did this almost instantly).
>>
>>     
> I'd suggest:
>
> # xfs_freeze -f /recovered
> # dd if=/dev/loop0 of=saved_file
> # xfs_freeze -u /recovered
>
> to be sure you get a consistent view of the fs.
>
> -Eric
>   

Many thanks to those who have replied. This solution does indeed work 
perfectly and
I have recovered my lost file.

Chris.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

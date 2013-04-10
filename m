Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B03867F8B
	for <xfs@oss.sgi.com>; Wed, 10 Apr 2013 09:17:49 -0500 (CDT)
Message-ID: <516574AD.7060706@sgi.com>
Date: Wed, 10 Apr 2013 09:18:21 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: New xfstests generic/308 causes XFS hang (high CPU use), at least
	on 32-bit
References: <51656D47.9010806@gmail.com> <516571CA.1020908@gmail.com>
In-Reply-To: <516571CA.1020908@gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: xfs@oss.sgi.com

On 04/10/2013 09:06 AM, Michael L. Semon wrote:
> On 04/10/2013 09:46 AM, Michael L. Semon wrote:
>
>> The PC uses kernel 3.8-rc4 + Dave's CRC v4 patches + J. Liu's bitness
>> patch.
>
> Oops, that was supposed to be "kernel 3.9-rc4."  Sorry.
>
> Michael
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

Runs fine on all my 64 bit machines.  I quickly ran a test using 
3.9.0-rc1+ on a 32 bit machine.  I am seeing the same xfs_io 100% CPU usage.

Looks 32 bit specific.

--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AA6648004
	for <xfs@oss.sgi.com>; Wed,  6 Mar 2013 06:59:40 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 915EF304048
	for <xfs@oss.sgi.com>; Wed,  6 Mar 2013 04:59:40 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id MwEtDyaiu7zR6ZPW for
	<xfs@oss.sgi.com>; Wed, 06 Mar 2013 04:59:39 -0800 (PST)
Message-ID: <51373DB8.2020707@redhat.com>
Date: Wed, 06 Mar 2013 07:59:36 -0500
From: Ric Wheeler <rwheeler@redhat.com>
MIME-Version: 1.0
Subject: Re: XFS filesystem on EC2 instance corrupts and shuts down
References: <CAOdS1h=7X4O1O7X8YOwxtLm7G=fc+J+6hJxJ1RKbDmfTZXTpeg@mail.gmail.com>
In-Reply-To: <CAOdS1h=7X4O1O7X8YOwxtLm7G=fc+J+6hJxJ1RKbDmfTZXTpeg@mail.gmail.com>
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
To: Shrinath M <shrinath.m@webyog.com>
Cc: Sabyasachi Ruj <sabyasachi.ruj@webyog.com>, Vivek Goel <vivek.goel@webyog.com>, xfs@oss.sgi.com

On 03/06/2013 03:07 AM, Shrinath M wrote:
> We are experiencing a strange XFS corruption issue. If we look in 
> /var/log/messages, it simply says -
>
>     Mar  5 01:14:33 ip-100-0-100-1 kernel: [14139930.248619] XFS (md0): 
> Corruption detected. Unmount and run xfs_repair
>
> It shuts down the filesystem after this. On rebooting, it calls xfs_repair 
> automatically and everything comes back to normal.
> We have had 2 such occurrences till now, I am attaching the relevant parts of 
> /var/log/messages here, assuming someone can enlighten me on whats going wrong.
>
> Machine details are as follows -
>
> We are using Amazon AMI version: Amazon Linux AMI release 2012.09 We are 
> running 8 EBS volumes of 512 MB each, in RAID 0 Array. $~: uname -a Linux 
> ip-100-0-100-1 3.2.34-55.46.amzn1.x86_64 #1 SMP Tue Nov 20 10:06:15 UTC 2012 
> x86_64 x86_64 x86_64 GNU/Linux
>
>
> Ask me if anyone wants any more details
>

I think that you would need to verify that the Amazon storage is not throwing 
errors - do your logs show IO errors or issues before XFS hits an issue?

Thanks!

Ric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

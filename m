Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5C6EB7CBE
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 13:02:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 49B6E8F8033
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 11:02:42 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id ADTfQYkZMxGJIYA1 for <xfs@oss.sgi.com>;
	Fri, 26 Apr 2013 11:02:38 -0700 (PDT)
Message-ID: <517AC13D.9000802@sandeen.net>
Date: Fri, 26 Apr 2013 13:02:37 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs module insert fails with "xfs: Unknown symbol
	exportfs_decode_fh (err 0)"
References: <1366997050.4098.14.camel@chandra-dt.ibm.com>
In-Reply-To: <1366997050.4098.14.camel@chandra-dt.ibm.com>
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
To: sekharan@us.ibm.com
Cc: XFS mailing list <xfs@oss.sgi.com>

On 4/26/13 12:24 PM, Chandra Seetharaman wrote:
> Hello,
> 
> When I tried to insert xfs module in my test machine it failed with 
> 
> 	xfs: Unknown symbol exportfs_decode_fh (err 0).

so don't use insmod, use modprobe :)

> Found out that I did not have CONFIG_EXPORTFS enabled in my kernel
> config. 

Oh, hum. But fs/xfs/Kconfig:

config XFS_FS
        tristate "XFS filesystem support"
        depends on BLOCK
        select EXPORTFS

it should be turned on automatically.  That seems to be the problem,
why wasn't it for your case?

> All .*by_handle code in XFS is open coded. Wondering if they should be
> under #ifdef CONFIG_EXPORTFS ?

CONFIG_EXPORTFS is supposed to be on if xfs is selected, unless something
changed recently.

-Eric

> I can create a patch, but wanted to find out if it is indeed needed :)
> 
> Regards,
> 
> Chandra
> 
> 
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

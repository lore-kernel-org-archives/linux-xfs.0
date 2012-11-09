Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA97iD7A085923 for <xfs@oss.sgi.com>; Fri, 9 Nov 2012 01:44:13 -0600
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id XuE3GIJ57SBUGBtD (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 08 Nov 2012 23:46:12 -0800 (PST)
Message-ID: <509CB4B6.10408@oracle.com>
Date: Fri, 09 Nov 2012 15:45:58 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: XFS AG disk layout described on official doc is wrong
References: <509CA70D.6000702@oracle.com> <20121109073654.GC6434@dastard>
In-Reply-To: <20121109073654.GC6434@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 11/09/2012 03:36 PM, Dave Chinner wrote:
> On Fri, Nov 09, 2012 at 02:47:41PM +0800, Jeff Liu wrote:
>> Hello,
>>
>> I observed that there is an issue on our official DOC for AG disk
>> layout, which can be found at:
>> http://xfs.org/docs/xfsdocs-xml-dev/XFS_Filesystem_Structure//tmp/en-US/html/Allocation_Groups.html
>>
>> It shows that the IBT block is followed by the block where AGFL sector
>> resides.  However, it should be followed by the
>> CNT block according to my debug, like below:
>>
>> -------------------------------
>> superblock
>> AG free block info
>> AG inode B+tree info
>> AG internal free list
>> -------------------------------
>> Root of free space B+tree
>>   B+tree key is block number
>> -------------------------------
>> Root of free space B+tree
>>   B+tree key is block count
>> --------------------------------
>> Root of inodes B+tree
>> --------------------------------
>>
>> Maybe the DOC is old, or am I missing anything?  If not, can we correct it?
> 
> The btree root blocks are dynamic. mkfs.xfs puts them in a fixed
> place, just like growfs does, but the moment you split a root block,
> it moves from that location. Hence the only way to reliably find the
> root btree block is to look up the point in the AGF/AGI, and that's
> what the document shows. IOWs, the ordering in the document is not
> important - the linkage is - as the root blocks can end up
> *anywhere* in the AG.
> 
> e.g:
> 
> $ sudo xfs_db -r -c "agf 0" -c p /dev/vda
> magicnum = 0x58414746
> versionnum = 1
> seqno = 0
> length = 262144
> bnoroot = 596
> cntroot = 1003
> bnolevel = 2
> cntlevel = 2
> ....
Ah, thanks for your quick response, now I understood. :)

Regards,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

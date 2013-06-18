Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3473029DF8
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 21:26:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 08E2D8F804C
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 19:26:03 -0700 (PDT)
Message-ID: <51BFC536.6030909@oracle.com>
Date: Tue, 18 Jun 2013 10:25:58 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: return FIEMAP_EXTENT_UNKNOWN for delayed allocation
	extent
References: <51B08D71.7090404@oracle.com> <20130617215353.GF20932@sgi.com>
In-Reply-To: <20130617215353.GF20932@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

Hi Ben,
On 06/18/2013 05:53 AM, Ben Myers wrote:

> Hey Jeff,
> 
> On Thu, Jun 06, 2013 at 06:24:01AM -0700, Jeff Liu wrote:
>> From: Jie Liu <jeff.liu@oracle.com>
>>
>> For FIEMAP ioctl(2), if an extent is in delayed allocation
>> state, we need to return the FIEMAP_EXTENT_UNKNOWN flag except
>> the FIEMAP_EXTENT_DELALLOC because its data location is unknown.
>>
>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> 
> Looks fine.  Is there an email thread I can reference?

I can't found an email thread to verify that, but according to
the specification of fiemap interface in kernel doc:
Documentation/filesystems/fiemap.txt

* FIEMAP_EXTENT_UNKNOWN
The location of this extent is currently unknown. This may indicate
the data is stored on an inaccessible volume or that no storage has
been allocated for the file yet.

* FIEMAP_EXTENT_DELALLOC
  - This will also set FIEMAP_EXTENT_UNKNOWN. 
    ^^^^^ <-- so the unknown flags should be set as well.

Delayed allocation - while there is data for this extent, its
physical location has not been allocated yet.

Also, Btrfs did it.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

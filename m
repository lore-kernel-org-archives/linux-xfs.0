Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1F37C7F3F
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 14:31:40 -0500 (CDT)
Date: Wed, 19 Jun 2013 14:31:39 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: return FIEMAP_EXTENT_UNKNOWN for delayed
	allocation extent
Message-ID: <20130619193139.GR20932@sgi.com>
References: <51B08D71.7090404@oracle.com> <20130617215353.GF20932@sgi.com>
	<51BFC536.6030909@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51BFC536.6030909@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: xfs@oss.sgi.com

Hey Jeff,

On Tue, Jun 18, 2013 at 10:25:58AM +0800, Jeff Liu wrote:
> On 06/18/2013 05:53 AM, Ben Myers wrote:
> > On Thu, Jun 06, 2013 at 06:24:01AM -0700, Jeff Liu wrote:
> >> From: Jie Liu <jeff.liu@oracle.com>
> >>
> >> For FIEMAP ioctl(2), if an extent is in delayed allocation
> >> state, we need to return the FIEMAP_EXTENT_UNKNOWN flag except
> >> the FIEMAP_EXTENT_DELALLOC because its data location is unknown.
> >>
> >> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> > 
> > Looks fine.  Is there an email thread I can reference?
> 
> I can't found an email thread to verify that, but according to
> the specification of fiemap interface in kernel doc:
> Documentation/filesystems/fiemap.txt
> 
> * FIEMAP_EXTENT_UNKNOWN
> The location of this extent is currently unknown. This may indicate
> the data is stored on an inaccessible volume or that no storage has
> been allocated for the file yet.
> 
> * FIEMAP_EXTENT_DELALLOC
>   - This will also set FIEMAP_EXTENT_UNKNOWN. 
>     ^^^^^ <-- so the unknown flags should be set as well.
> 
> Delayed allocation - while there is data for this extent, its
> physical location has not been allocated yet.

Thanks.  That's just what I needed.  Applied.

> Also, Btrfs did it.

Heh.  Must be right then!  ;)

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

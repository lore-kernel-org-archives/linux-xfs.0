Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0EEBE7FD8
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 19:55:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E4460304059
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 17:55:26 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	hl1EidHuyPNvRNHc for <xfs@oss.sgi.com>;
	Mon, 07 Apr 2014 17:55:25 -0700 (PDT)
Date: Tue, 8 Apr 2014 10:54:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/3] fs: Introduce FALLOC_FL_INSERT_RANGE for fallocate
Message-ID: <20140408005417.GI27017@dastard>
References: <1396277611-10759-1-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1396277611-10759-1-git-send-email-linkinjeon@gmail.com>
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
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: jack@suse.cz, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, lczerner@redhat.com, linux-fsdevel@vger.kernel.org, tytso@mit.edu, linux-ext4@vger.kernel.org

On Mon, Mar 31, 2014 at 11:53:31PM +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> FALLOC_FL_INSERT_RANGE was mentioned as the opposite command of collapse
> range from discussion between Hugh Dickins and Dave Chinner.
> 
> In continuation of the work of making the process of non linear editing of
> media files faster, we introduce here the new flag FALLOC_FL_INSERT_RANGE
> for fallocate.
> 
> This flag will work opposite to the newly added FALLOC_FL_COLLAPSE_RANGE flag.
> As such, specifying FALLOC_FL_INSERT_RANGE flag will insert zeroed-out space
> in between the file within the range specified by offset and len. User can
> write new data in this space. e.g. ads.
> Like collapse range, currently we have the limitation that offset and len
> should be block size aligned for both XFS and Ext4.
> 
> The semantics of the flag are :
> 1) It allocates new zeroed out on disk space of len bytes starting
>    at offset byte without overwriting any existing data. All the data blocks
>    from offset to EOF are shifted towards right to make space for inserting
>    new blocks
> 2) It should be used exclusively. No other fallocate flag in combination.
> 3) Offset and length supplied to fallocate should be fs block size aligned
>    in case of xfs and ext4.
> 4) Insert range does not work for the case when offset is overlapping/beyond
>    i_size. If the user wants to allocate space at the end of file they are
>    advised to use either ftruncate(2) or fallocate(2) with mode 0.
> 5) It increses the size of file by len bytes.
> 
> Namjae Jeon (3):
>  fs: Add FALLOC_FL_INSERT_RANGE flags for fallocate
>  xfs: Add support FALLOC_FL_INSERT_RANGE for fallocate
>  ext4: Add support FALLOC_FL_INSERT_RANGE for fallocate
>  TODO : xfsprog: xfsio: Add support FALLOC_FL_INSERT_RANGE for fallocate
>  TODO : xfstests: Add insert range testcase

Namjae, what's your proposed timeframe on getting the xfs_io and tes
cases sorted out? I'm just trying to plan ahead for the next couple
of months (i.e. the 3.16 merge cycle), so some indication of whether
I can expect this to be complete and ready for merge within that
timeframe would be helpful to me.

FWIW, it would be really nice if you could add support for fsx and
fsstress for this as well as adding corner case tests. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

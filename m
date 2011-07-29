Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6TKqhDn067369 for <xfs@oss.sgi.com>; Fri, 29 Jul 2011 15:52:44 -0500
Received: from mx2.netapp.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 15235F1E983
	for <xfs@oss.sgi.com>; Fri, 29 Jul 2011 13:53:04 -0700 (PDT)
Received: from mx2.netapp.com (mx2.netapp.com [216.240.18.37]) by cuda.sgi.com
	with ESMTP id o0BG4FcVoMifHCuB for <xfs@oss.sgi.com>;
	Fri, 29 Jul 2011 13:53:04 -0700 (PDT)
Message-ID: <4E331D86.7060801@netapp.com>
Date: Fri, 29 Jul 2011 16:52:22 -0400
From: Bryan Schumaker <bjschuma@netapp.com>
MIME-Version: 1.0
Subject: Re: 2.6.xx: NFS: directory motion/cam2 contains a readdir loop
References: <alpine.DEB.2.02.1107270952270.1451@p34.internal.lan>
	<20110727160752.GC974@fieldses.org>
	<alpine.DEB.2.02.1107271227340.1451@p34.internal.lan>
	<20110727181111.GA23009@infradead.org>
	<alpine.DEB.2.02.1107271530340.1451@p34.internal.lan>
	<20110727193937.GA5354@infradead.org>
	<alpine.DEB.2.02.1107271540100.1451@p34.internal.lan>
	<20110727194722.GA9345@infradead.org>
	<1311799021.25645.41.camel@lade.trondhjem.org>
	<1311800051.25645.43.camel@lade.trondhjem.org>
	<1311800195.25645.45.camel@lade.trondhjem.org>
	<alpine.DEB.2.02.1107271723500.25432@p34.internal.lan>
	<alpine.DEB.2.02.1107271844100.25432@p34.internal.lan>
	<1311886137.27285.2.camel@lade.trondhjem.org>
In-Reply-To: <1311886137.27285.2.camel@lade.trondhjem.org>
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
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Justin Piszcz <jpiszcz@lucidpixels.com>

On 07/28/2011 04:48 PM, Trond Myklebust wrote:
> On Wed, 2011-07-27 at 18:44 -0400, Justin Piszcz wrote: 
>>
>> On Wed, 27 Jul 2011, Justin Piszcz wrote:
>>
>>>
>>>
>>> On Wed, 27 Jul 2011, Trond Myklebust wrote:
>>>
>>>> On Wed, 2011-07-27 at 16:54 -0400, Trond Myklebust wrote:
>>>>> On Wed, 2011-07-27 at 16:37 -0400, Trond Myklebust wrote:
>>>>>> On Wed, 2011-07-27 at 15:47 -0400, Christoph Hellwig wrote:
>>>>>>> On Wed, Jul 27, 2011 at 03:44:20PM -0400, Justin Piszcz wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>> On Wed, 27 Jul 2011, Christoph Hellwig wrote:
>>>>>>>>
>>>>>>>>> On Wed, Jul 27, 2011 at 03:35:01PM -0400, Justin Piszcz wrote:
>>>>>>>>>> Currently I do not see any dupes, however I have a script that moves
>>>>>>>>>> images out of the directory once an hour:
>>>>>>>>>> 0 * * * * /usr/local/bin/move_to_old2.sh > /dev/null 2>&1
>>>>>>>>>
>>>>>>>>> Do you keep adding files to the directory while you move files out?
>>>>>>>> Yes, otherwise there are too many files in the directory and viewers, e.g.,
>>>>>>>> each geeqie (picture viewer) will use > 4-6GB of memory, so I try to keep
>>>>>>>> it around 5,000 pictures or less.
>>>>>>>>
>>>>>>>>> What's the rate of additions/removals to the directory?
>>>>>>>> Additions it depends, around 5,000 over a 12hr period, 416/hr, current:
>>>>>>>>
>>>>>>>> atom:/d1/motion# find cam1|wc
>>>>>>>>    5215    5215  166853
>>>>>>>> atom:/d1/motion# find cam2|wc
>>>>>>>>    5069    5069  162181
>>>>>>>> atom:/d1/motion# find cam3|wc
>>>>>>>>    5594    5594  178981
>>>>>>>> atom:/d1/motion#
>>>>>>>
>>>>>>> This sounds a lot like xfs simply filling up the directory index slots
>>>>>>> of files that you just moved out with new files, and nfs falsely
>>>>>>> claiming that this is a problem.
>>>>>>
>>>>>> Yep. There is an existing bugzilla report for this bug at
>>>>>>
>>>>>>    https://bugzilla.kernel.org/show_bug.cgi?id=38572
>>>>>>
>>>>>> I have a preliminary patch there that attempts to turn off the loop
>>>>>> detection when the directory is seen to change, however that patch still
>>>>>> appears to have a bug in it, and I haven't had time to figure out what
>>>>>> is wrong yet.
>>>>>>
>>>>>> Can you perhaps take a look, Bryan?
>>>>>
>>>>> Actually, Justin, can you test the following slight variant on the patch
>>>>> in the bugzilla?
>>>>
>>>> Doh! This one will actually compile....
>>>
>>> Hi,
>>>
>>> Should I try 3.0 first or retry 2.6.38 w/ this patch?
>>>
>>> Justin.
>>>
>>>
>>
>> I'll give 3.0 a go first.
> 
> I had Bryan do some more tests, which revealed a couple more issues. The
> attached patch should fix those, and has resisted everything we've
> thrown at it so far. It should apply to 2.6.39 and newer.

This patch still looks good (after testing it a bit more today).

How does this look for printing out more information when a cookie loop is detected?  Is there anything else that should be printed out?  My patch applies on top of Trond's from yesterday.

- Bryan

8<-----------------------------------------------------------------------
>From 4d74863dc2bcd4e603a873b3725f0a05afd21f1f Mon Sep 17 00:00:00 2001
From: Bryan Schumaker <bjschuma@netapp.com>
Date: Fri, 29 Jul 2011 11:49:06 -0400
Subject: [PATCH] Additional readdir cookie loop information

Print out the name of the file that triggers the cookie loop  message to
make it slightly easier to track down the cause.

Signed-off-by: Bryan Schumaker <bjschuma@netapp.com>
---
 fs/nfs/dir.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index d23108b..b238d95 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -365,9 +365,10 @@ int nfs_readdir_search_for_cookie(struct nfs_cache_array *array, nfs_readdir_des
 					if (printk_ratelimit()) {
 						pr_notice("NFS: directory %s/%s contains a readdir loop."
 								"Please contact your server vendor.  "
-								"Offending cookie: %llu\n",
+								"The file: %s has duplicate cookie %llu\n",
 								desc->file->f_dentry->d_parent->d_name.name,
 								desc->file->f_dentry->d_name.name,
+								array->array[i].string.name,
 								*desc->dir_cookie);
 					}
 					status = -ELOOP;
-- 
1.7.6


> 
> Cheers
>   Trond
> 8<----------------------------------------------------------------------- 
> From 75c0387540737a6663338d4ec0538bd6fb724173 Mon Sep 17 00:00:00 2001
> From: Trond Myklebust <Trond.Myklebust@netapp.com>
> Date: Thu, 28 Jul 2011 16:34:33 -0400
> Subject: [PATCH v3] NFS: Fix spurious readdir cookie loop messages
> 
> If the directory contents change, then we have to accept that the
> file->f_pos value may shrink if we do a 'search-by-cookie'. In that
> case, we should turn off the loop detection and let the NFS client
> try to recover.
> 
> The patch also fixes a second loop detection bug by ensuring
> that after turning on the ctx->duped flag, we read at least one new
> cookie into ctx->dir_cookie before attempting to match with
> ctx->dup_cookie.
> 
> Reported-by: Petr Vandrovec <petr@vandrovec.name>
> Cc: stable@kernel.org [2.6.39+]
> Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> ---
>  fs/nfs/dir.c           |   56 ++++++++++++++++++++++++++++-------------------
>  include/linux/nfs_fs.h |    3 +-
>  2 files changed, 35 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
> index 57f578e..d23108b 100644
> --- a/fs/nfs/dir.c
> +++ b/fs/nfs/dir.c
> @@ -134,18 +134,19 @@ const struct inode_operations nfs4_dir_inode_operations = {
>  
>  #endif /* CONFIG_NFS_V4 */
>  
> -static struct nfs_open_dir_context *alloc_nfs_open_dir_context(struct rpc_cred *cred)
> +static struct nfs_open_dir_context *alloc_nfs_open_dir_context(struct inode *dir, struct rpc_cred *cred)
>  {
>  	struct nfs_open_dir_context *ctx;
>  	ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
>  	if (ctx != NULL) {
>  		ctx->duped = 0;
> +		ctx->attr_gencount = NFS_I(dir)->attr_gencount;
>  		ctx->dir_cookie = 0;
>  		ctx->dup_cookie = 0;
>  		ctx->cred = get_rpccred(cred);
> -	} else
> -		ctx = ERR_PTR(-ENOMEM);
> -	return ctx;
> +		return ctx;
> +	}
> +	return  ERR_PTR(-ENOMEM);
>  }
>  
>  static void put_nfs_open_dir_context(struct nfs_open_dir_context *ctx)
> @@ -173,7 +174,7 @@ nfs_opendir(struct inode *inode, struct file *filp)
>  	cred = rpc_lookup_cred();
>  	if (IS_ERR(cred))
>  		return PTR_ERR(cred);
> -	ctx = alloc_nfs_open_dir_context(cred);
> +	ctx = alloc_nfs_open_dir_context(inode, cred);
>  	if (IS_ERR(ctx)) {
>  		res = PTR_ERR(ctx);
>  		goto out;
> @@ -323,7 +324,6 @@ int nfs_readdir_search_for_pos(struct nfs_cache_array *array, nfs_readdir_descri
>  {
>  	loff_t diff = desc->file->f_pos - desc->current_index;
>  	unsigned int index;
> -	struct nfs_open_dir_context *ctx = desc->file->private_data;
>  
>  	if (diff < 0)
>  		goto out_eof;
> @@ -336,7 +336,6 @@ int nfs_readdir_search_for_pos(struct nfs_cache_array *array, nfs_readdir_descri
>  	index = (unsigned int)diff;
>  	*desc->dir_cookie = array->array[index].cookie;
>  	desc->cache_entry_index = index;
> -	ctx->duped = 0;
>  	return 0;
>  out_eof:
>  	desc->eof = 1;
> @@ -349,14 +348,33 @@ int nfs_readdir_search_for_cookie(struct nfs_cache_array *array, nfs_readdir_des
>  	int i;
>  	loff_t new_pos;
>  	int status = -EAGAIN;
> -	struct nfs_open_dir_context *ctx = desc->file->private_data;
>  
>  	for (i = 0; i < array->size; i++) {
>  		if (array->array[i].cookie == *desc->dir_cookie) {
> +			struct nfs_inode *nfsi = NFS_I(desc->file->f_path.dentry->d_inode);
> +			struct nfs_open_dir_context *ctx = desc->file->private_data;
> +
>  			new_pos = desc->current_index + i;
> -			if (new_pos < desc->file->f_pos) {
> +			if (ctx->attr_gencount != nfsi->attr_gencount
> +			    || (nfsi->cache_validity & (NFS_INO_INVALID_ATTR|NFS_INO_INVALID_DATA))) {
> +				ctx->duped = 0;
> +				ctx->attr_gencount = nfsi->attr_gencount;
> +			} else if (new_pos < desc->file->f_pos) {
> +				if (ctx->duped > 0
> +				    && ctx->dup_cookie == *desc->dir_cookie) {
> +					if (printk_ratelimit()) {
> +						pr_notice("NFS: directory %s/%s contains a readdir loop."
> +								"Please contact your server vendor.  "
> +								"Offending cookie: %llu\n",
> +								desc->file->f_dentry->d_parent->d_name.name,
> +								desc->file->f_dentry->d_name.name,
> +								*desc->dir_cookie);
> +					}
> +					status = -ELOOP;
> +					goto out;
> +				}
>  				ctx->dup_cookie = *desc->dir_cookie;
> -				ctx->duped = 1;
> +				ctx->duped = -1;
>  			}
>  			desc->file->f_pos = new_pos;
>  			desc->cache_entry_index = i;
> @@ -368,6 +386,7 @@ int nfs_readdir_search_for_cookie(struct nfs_cache_array *array, nfs_readdir_des
>  		if (*desc->dir_cookie == array->last_cookie)
>  			desc->eof = 1;
>  	}
> +out:
>  	return status;
>  }
>  
> @@ -740,19 +759,6 @@ int nfs_do_filldir(nfs_readdir_descriptor_t *desc, void *dirent,
>  	struct nfs_cache_array *array = NULL;
>  	struct nfs_open_dir_context *ctx = file->private_data;
>  
> -	if (ctx->duped != 0 && ctx->dup_cookie == *desc->dir_cookie) {
> -		if (printk_ratelimit()) {
> -			pr_notice("NFS: directory %s/%s contains a readdir loop.  "
> -				"Please contact your server vendor.  "
> -				"Offending cookie: %llu\n",
> -				file->f_dentry->d_parent->d_name.name,
> -				file->f_dentry->d_name.name,
> -				*desc->dir_cookie);
> -		}
> -		res = -ELOOP;
> -		goto out;
> -	}
> -
>  	array = nfs_readdir_get_array(desc->page);
>  	if (IS_ERR(array)) {
>  		res = PTR_ERR(array);
> @@ -774,6 +780,8 @@ int nfs_do_filldir(nfs_readdir_descriptor_t *desc, void *dirent,
>  			*desc->dir_cookie = array->array[i+1].cookie;
>  		else
>  			*desc->dir_cookie = array->last_cookie;
> +		if (ctx->duped != 0)
> +			ctx->duped = 1;
>  	}
>  	if (array->eof_index >= 0)
>  		desc->eof = 1;
> @@ -805,6 +813,7 @@ int uncached_readdir(nfs_readdir_descriptor_t *desc, void *dirent,
>  	struct page	*page = NULL;
>  	int		status;
>  	struct inode *inode = desc->file->f_path.dentry->d_inode;
> +	struct nfs_open_dir_context *ctx = desc->file->private_data;
>  
>  	dfprintk(DIRCACHE, "NFS: uncached_readdir() searching for cookie %Lu\n",
>  			(unsigned long long)*desc->dir_cookie);
> @@ -818,6 +827,7 @@ int uncached_readdir(nfs_readdir_descriptor_t *desc, void *dirent,
>  	desc->page_index = 0;
>  	desc->last_cookie = *desc->dir_cookie;
>  	desc->page = page;
> +	ctx->duped = 0;
>  
>  	status = nfs_readdir_xdr_to_array(desc, page, inode);
>  	if (status < 0)
> diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
> index 8b579be..b96fb99 100644
> --- a/include/linux/nfs_fs.h
> +++ b/include/linux/nfs_fs.h
> @@ -99,9 +99,10 @@ struct nfs_open_context {
>  
>  struct nfs_open_dir_context {
>  	struct rpc_cred *cred;
> +	unsigned long attr_gencount;
>  	__u64 dir_cookie;
>  	__u64 dup_cookie;
> -	int duped;
> +	signed char duped;
>  };
>  
>  /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

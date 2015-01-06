Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 060437F6F
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 12:13:04 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D6D9A8F8039
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 10:13:03 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id BlmNuREX2wqHRZ2Q (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2015 10:13:02 -0800 (PST)
Date: Tue, 6 Jan 2015 13:12:55 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v7 4/11] xfsprogs: xfs_io: add finsert command for insert
	range via fallocate
Message-ID: <20150106181255.GG5874@bfoster.bfoster>
References: <004201d02670$45154980$cf3fdc80$@samsung.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <004201d02670$45154980$cf3fdc80$@samsung.com>
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
To: Namjae Jeon <namjae.jeon@samsung.com>
Cc: Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ashish Sangwan <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>

On Fri, Jan 02, 2015 at 06:41:23PM +0900, Namjae Jeon wrote:
> Add finsert command for fallocate FALLOC_FL_INSERT_RANGE flag.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> ---

Looks good...

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  io/prealloc.c | 39 ++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 38 insertions(+), 1 deletion(-)
> 
> diff --git a/io/prealloc.c b/io/prealloc.c
> index aba6b44..11b1e12 100644
> --- a/io/prealloc.c
> +++ b/io/prealloc.c
> @@ -37,6 +37,10 @@
>  #define FALLOC_FL_ZERO_RANGE 0x10
>  #endif
>  
> +#ifndef FALLOC_FL_INSERT_RANGE
> +#define FALLOC_FL_INSERT_RANGE 0x20
> +#endif
> +
>  static cmdinfo_t allocsp_cmd;
>  static cmdinfo_t freesp_cmd;
>  static cmdinfo_t resvsp_cmd;
> @@ -46,6 +50,7 @@ static cmdinfo_t zero_cmd;
>  static cmdinfo_t falloc_cmd;
>  static cmdinfo_t fpunch_cmd;
>  static cmdinfo_t fcollapse_cmd;
> +static cmdinfo_t finsert_cmd;
>  static cmdinfo_t fzero_cmd;
>  #endif
>  
> @@ -169,11 +174,14 @@ fallocate_f(
>  	int		mode = 0;
>  	int		c;
>  
> -	while ((c = getopt(argc, argv, "ckp")) != EOF) {
> +	while ((c = getopt(argc, argv, "cikp")) != EOF) {
>  		switch (c) {
>  		case 'c':
>  			mode = FALLOC_FL_COLLAPSE_RANGE;
>  			break;
> +		case 'i':
> +			mode = FALLOC_FL_INSERT_RANGE;
> +			break;
>  		case 'k':
>  			mode = FALLOC_FL_KEEP_SIZE;
>  			break;
> @@ -237,6 +245,25 @@ fcollapse_f(
>  }
>  
>  static int
> +finsert_f(
> +	int		argc,
> +	char		**argv)
> +{
> +	xfs_flock64_t	segment;
> +	int		mode = FALLOC_FL_INSERT_RANGE;
> +
> +	if (!offset_length(argv[1], argv[2], &segment))
> +		return 0;
> +
> +	if (fallocate(file->fd, mode,
> +			segment.l_start, segment.l_len)) {
> +		perror("fallocate");
> +		return 0;
> +	}
> +	return 0;
> +}
> +
> +static int
>  fzero_f(
>  	int		argc,
>  	char		**argv)
> @@ -345,6 +372,16 @@ prealloc_init(void)
>  	_("de-allocates space and eliminates the hole by shifting extents");
>  	add_command(&fcollapse_cmd);
>  
> +	finsert_cmd.name = "finsert";
> +	finsert_cmd.cfunc = finsert_f;
> +	finsert_cmd.argmin = 2;
> +	finsert_cmd.argmax = 2;
> +	finsert_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
> +	finsert_cmd.args = _("off len");
> +	finsert_cmd.oneline =
> +	_("creates new space for writing within file by shifting extents");
> +	add_command(&finsert_cmd);
> +
>  	fzero_cmd.name = "fzero";
>  	fzero_cmd.cfunc = fzero_f;
>  	fzero_cmd.argmin = 2;
> -- 
> 1.7.11-rc0
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

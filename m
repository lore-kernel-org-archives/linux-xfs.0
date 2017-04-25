Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44217 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S980084AbdDYDEW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Apr 2017 23:04:22 -0400
Date: Tue, 25 Apr 2017 05:04:21 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 04/12] mkfs: merge tables for opts parsing into one table
Message-ID: <20170425030421.GH28800@wotan.suse.de>
References: <20170423185503.31415-1-jtulak@redhat.com>
 <20170423185503.31415-5-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170423185503.31415-5-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Apr 23, 2017 at 08:54:55PM +0200, Jan Tulak wrote:
> Merge separate instances of opt_params into one indexable table. Git
> makes this patch looks a bit more complicated, but it does not change
> values or structure of anything else. It only moves all the "struct
> opt_params dopts = {...}", changes indentation for these substructures
> and replaces their usage (dopts -> opts[OPT_D]).
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> ---
>  mkfs/xfs_mkfs.c | 1316 +++++++++++++++++++++++++++++--------------------------
>  1 file changed, 683 insertions(+), 633 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 7a72b11..513e106 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -42,6 +42,7 @@ static int  ispow2(unsigned int i);
>  uint64_t		blocksize;
>  uint64_t		sectorsize;
>  
> +#define MAX_OPTS	16

This is fragile, every time a new opt is added this needs to be updated
and so is the index, and we should be pedantic over not going out of bounds.
We could instead use a flexible array and compute the max opts at run time
as a global. This way the max opts is always updated automatically.

>  #define MAX_SUBOPTS	16
>  #define SUBOPT_NEEDS_VAL	(-1LL)
>  #define MAX_CONFLICTS	8
> @@ -60,6 +61,10 @@ uint64_t		sectorsize;
>   *
>   * Description of the structure members follows:
>   *
> + * index MANDATORY
> + *   An integer denoting the position of the specific option in opts array,
> + *   counting from 0 up to MAX_OPTS.
> + *
>   * name MANDATORY
>   *   Name is a single char, e.g., for '-d file', name is 'd'.
>   *
> @@ -132,6 +137,7 @@ uint64_t		sectorsize;
>   * !!! END OF NOTE ===========================================================
>   */
>  struct opt_params {
> +	int		index;


>  	const char	name;
>  	const char	*subopts[MAX_SUBOPTS];
>  
> @@ -147,584 +153,592 @@ struct opt_params {
>  		uint64_t	flagval;
>  		const char	*raw_input;
>  	}		subopt_params[MAX_SUBOPTS];
> -};
> -
> -struct opt_params bopts = {
> -	.name = 'b',
> -	.subopts = {
> +} 

Do we really need to mesh the struct with the opts below ? I think it would
make your patch easier to read if we kept the old tradition of splitting it,
its not clear to me what the advantage is.

> opts[MAX_OPTS] = {
> +#define OPT_B	0

I find these defines blinding on reading the struct declaration, we could
instead just stuff them into an enum, which would also enable us to shift all
the documentation into the header of the enum using whatever doc format we use.

Below is a simple demo using a basic limited opt just to be clear about what I
am suggesting, modulo, I think we want max_opts to be a global.

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))

enum opt_idx {
	OPT_ZERO = 0,
	OPT_ONE,
	OPT_TWO,
};

struct opt {
	unsigned int idx;
	unsigned int val;
};

struct opt opts[] = {
	{
		.idx = OPT_ZERO,
		.val = 0,
	},
	{
		.idx = OPT_ONE,
		.val = 1,
	},
	{
		.idx = OPT_TWO,
		.val = 2,
	},
};

int main(int argc, char *argv[])
{
	unsigned int max_opts = ARRAY_SIZE(opts);
	unsigned int i;

	printf("Max size: %lu\n", max_opts);

	for (i = 0; i < max_opts; i++) {
		printf("Val: %lu\n", opts[i].val);
	}

	return 0;
}

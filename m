Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:41370 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725744AbeKYFMq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 25 Nov 2018 00:12:46 -0500
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH 06/12] fsx: add five-argument logging function
References: <154290950237.1218.9937108728673485814.stgit@magnolia>
 <154290954603.1218.7246941650070239499.stgit@magnolia>
Message-ID: <d5378b1b-3995-1918-8424-6b7ed21dda97@oracle.com>
Date: Sat, 24 Nov 2018 11:23:39 -0700
MIME-Version: 1.0
In-Reply-To: <154290954603.1218.7246941650070239499.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, guaneryu@gmail.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Ok, you can add my review:

Reviewed-By: Allison Henderson <allison.henderson@oracle.com>

On 11/22/18 10:59 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a five-argument logging function to support new operations.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   ltp/fsx.c |   45 ++++++++++++++++++++++++++++++++++++++++-----
>   1 file changed, 40 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/ltp/fsx.c b/ltp/fsx.c
> index dabad302..c525ba13 100644
> --- a/ltp/fsx.c
> +++ b/ltp/fsx.c
> @@ -51,7 +51,8 @@ enum opflags { FL_NONE = 0, FL_SKIPPED = 1, FL_CLOSE_OPEN = 2, FL_KEEP_SIZE = 4
>   
>   struct log_entry {
>   	int	operation;
> -	int	args[3];
> +	int	nr_args;
> +	int	args[4];
>   	enum opflags flags;
>   };
>   
> @@ -278,6 +279,27 @@ static int op_code(const char *name)
>   	return -1;
>   }
>   
> +void
> +log5(int operation, int arg0, int arg1, int arg2, enum opflags flags)
> +{
> +	struct log_entry *le;
> +
> +	le = &oplog[logptr];
> +	le->operation = operation;
> +	if (closeopen)
> +		flags |= FL_CLOSE_OPEN;
> +	le->args[0] = arg0;
> +	le->args[1] = arg1;
> +	le->args[2] = arg2;
> +	le->args[3] = file_size;
> +	le->nr_args = 4;
> +	le->flags = flags;
> +	logptr++;
> +	logcount++;
> +	if (logptr >= LOGSIZE)
> +		logptr = 0;
> +}
> +
>   void
>   log4(int operation, int arg0, int arg1, enum opflags flags)
>   {
> @@ -290,6 +312,7 @@ log4(int operation, int arg0, int arg1, enum opflags flags)
>   	le->args[0] = arg0;
>   	le->args[1] = arg1;
>   	le->args[2] = file_size;
> +	le->nr_args = 3;
>   	le->flags = flags;
>   	logptr++;
>   	logcount++;
> @@ -439,11 +462,13 @@ logdump(void)
>   			i = 0;
>   
>   		if (logopsf) {
> +			int j;
> +
>   			if (lp->flags & FL_SKIPPED)
>   				fprintf(logopsf, "skip ");
> -			fprintf(logopsf, "%s 0x%x 0x%x 0x%x",
> -				op_name(lp->operation),
> -				lp->args[0], lp->args[1], lp->args[2]);
> +			fprintf(logopsf, "%s", op_name(lp->operation));
> +			for (j = 0; j < lp->nr_args; j++)
> +				fprintf(logopsf, " 0x%x", lp->args[j]);
>   			if (lp->flags & FL_KEEP_SIZE)
>   				fprintf(logopsf, " keep_size");
>   			if (lp->flags & FL_CLOSE_OPEN)
> @@ -1413,6 +1438,15 @@ cleanup(int sig)
>   	exit(sig);
>   }
>   
> +static int
> +op_args_count(int operation)
> +{
> +	switch (operation) {
> +	default:
> +		return 3;
> +	}
> +}
> +
>   static int
>   read_op(struct log_entry *log_entry)
>   {
> @@ -1445,7 +1479,8 @@ read_op(struct log_entry *log_entry)
>   		log_entry->operation = op_code(str);
>   		if (log_entry->operation == -1)
>   			goto fail;
> -		for (i = 0; i < 3; i++) {
> +		log_entry->nr_args = op_args_count(log_entry->operation);
> +		for (i = 0; i < log_entry->nr_args; i++) {
>   			char *end;
>   
>   			str = strtok(NULL, " \t\n");
> 

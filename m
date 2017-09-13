Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39362 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750993AbdIMN5H (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 Sep 2017 09:57:07 -0400
Subject: Re: [PATCH v2] xfs_repair: don't use do_warn for normal log message
References: <20170913113044.23081-1-yamato@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <749512b4-ec1a-3527-8db9-47a738ba40c8@sandeen.net>
Date: Wed, 13 Sep 2017 08:57:06 -0500
MIME-Version: 1.0
In-Reply-To: <20170913113044.23081-1-yamato@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Masatake YAMATO <yamato@redhat.com>, linux-xfs@vger.kernel.org

On 9/13/17 6:30 AM, Masatake YAMATO wrote:
> In some case, exit statuses of xfs_repair -n are different even for the
> same file system when -v is specified or not. This patch fixes this
> behavior.

Ah yes, we've fixed some of these before I think, though I can't find
them now... there's at least one more in main(), 

               if (fstat(fd, &statbuf) < 0)
                       do_warn(_("%s: couldn't stat \"%s\"\n"),
                               progname, fs_name);

This patch looks fine, though, thanks:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> If -v is specified, do_warn() is used in zero_log() for printing
> a normal message. That makes the exit status to 1 though there
> is no dirtiness in the file system.
> 
> The original zero_log():
> 
> 	error = xlog_find_tail(log, &head_blk, &tail_blk);
> 	if (error) {...
> 	} else {
> 		if (verbose) {
> 			do_warn(
> 	_("zero_log: head block %" PRId64 " tail block %" PRId64 "\n"),
> 				head_blk, tail_blkn);
> 		}
> 
> do_warn() is used for the message, "zero_log:...".  do_log
> should be used instead because this log message is for just reporting the
> values of head_blk, and tail_blk. do_log is for "just reporting".
> 
> Using do_warn unintentionally has an impact.
> It causes the exit status of the command.
> do_warn sets fs_is_dirty global variable.
> That refers in main function to decide the exit status.
> 
>     void
>     do_warn(char const *msg, ...)
>     {
> 	    va_list args;
> 
> 	    fs_is_dirty = 1;
> 
>     int
>     main(int argc, char **argv)
>     {
>     ...
> 
> 		    if (fs_is_dirty)
> 			    return(1);
> 
> Signed-off-by: Masatake YAMATO <yamato@redhat.com>
> ---
>  Please, ignore the original patch I submitted a few minutes ago.
>  The change is applied to wrong if/else block in the original patch.
>  
>  repair/phase2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/repair/phase2.c b/repair/phase2.c
> index c21778b8..850cd99e 100644
> --- a/repair/phase2.c
> +++ b/repair/phase2.c
> @@ -86,7 +86,7 @@ zero_log(
>  			exit(2);
>  	} else {
>  		if (verbose) {
> -			do_warn(
> +			do_log(
>  	_("zero_log: head block %" PRId64 " tail block %" PRId64 "\n"),
>  				head_blk, tail_blk);
>  		}
> 

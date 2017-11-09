Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:44106 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751110AbdKIUdY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Nov 2017 15:33:24 -0500
Subject: Re: [PATCH v4 1/4] xfs_io: Disable -V if pwritev is not available
References: <20171109192648.6356-1-rgoldwyn@suse.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <500e2ae5-7eed-c768-98d2-9058572b43be@sandeen.net>
Date: Thu, 9 Nov 2017 14:33:23 -0600
MIME-Version: 1.0
In-Reply-To: <20171109192648.6356-1-rgoldwyn@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-xfs@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>



On 11/9/17 1:26 PM, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> This results in default case which will display the error message
> that command is not found. This is required for xfs_io builds which
> did not support pwritev and an attempt is made to use -V.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  io/pwrite.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/io/pwrite.c b/io/pwrite.c
> index 1c5dfca1..5f149a68 100644
> --- a/io/pwrite.c
> +++ b/io/pwrite.c
> @@ -312,6 +312,7 @@ pwrite_f(
>  		case 'u':
>  			uflag = 1;
>  			break;
> +#ifdef HAVE_PWRITEV
>  		case 'V':
>  			vectors = strtoul(optarg, &sp, 0);
>  			if (!sp || sp == optarg) {
> @@ -320,6 +321,7 @@ pwrite_f(
>  				return 0;
>  			}
>  			break;
> +#endif
>  		case 'w':
>  			wflag = 1;
>  			break;
> @@ -334,6 +336,7 @@ pwrite_f(
>  			}
>  			break;
>  		default:
> +			printf(_("command -%c not supported\n"), c);
>  			return command_usage(&pwrite_cmd);
>  		}
>  	}

I think this is slightly better:

                default:
                        /* Handle ifdef'd-out options above */
                        if (c != '?')
                                printf(_("%s: command -%c not supported\n"), argv[0], c);
                        return command_usage(&pwrite_cmd);
                }

so we don't get the message for a completely bogus (not in getopt string)
argument on top of the one getopt already gives us.

I can do it on the way in.

Other than that, 

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Thanks,
-Eric


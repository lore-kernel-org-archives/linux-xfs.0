Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9045C43331
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 21:46:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7865206A3
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 21:46:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S117aSEn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbfKGVqN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 16:46:13 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46575 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfKGVqN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 16:46:13 -0500
Received: by mail-pl1-f196.google.com with SMTP id l4so2482810plt.13
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 13:46:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mGtlQ5WzMwSVAPKL3beecikHaKz3Uhi6vfP2HQGtuGs=;
        b=S117aSEn1uuRv+7kLtKq6HK+vWNqjOEmAUbW4rc9Wg260VkRNX+V9gpTYIxKclj7Ce
         IT8BHfMau4J3Y9VBCKjpDxnQ4XU3bJ0luW4jUiJTY2yzoxThK+2zXMHUeGt2U7r4uuNP
         NDHJZS0nxxpJ9LB4mkK/e/M7vqucPsRwZicbPxqoXTJHUBzU3KZNLsDukGBPCsrcZj1y
         HNT7N0d1t+k+w7KS9OE9FGVyB4RnHswDU8hfS6XOk4Y/tRj+U/LrJGRER7Ad2HkDKpnD
         9fxwojnzO8WVH6yTGTvy4WuJOv+tPv7rLx3TCfLT5JAzQlpcL7PEg20WxrHlkWlKRzka
         HuMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=mGtlQ5WzMwSVAPKL3beecikHaKz3Uhi6vfP2HQGtuGs=;
        b=Vj3XfPRqSL/75gSiPF6qR3AtK4fUXR5RrUhKabseveycSt6rkfMMkBaJPRFAEmCLn5
         rK5nT8+n3hY3GUYahemYALdOqzW2gd3keW0oqHhSbq5wvm2cANpjX1mqa4yTWRgW9QA3
         MZoQqJu/Cvip1Grr6TKqAzAlp8zDBDc7vi0gPevMhhn83ZlzKOPyRf1MBnJCkhu4rJCB
         un2J8uLBUMHKM6fdtV4Hlj87dB2iCZAaE0IELgPQs0frkC3gaeJ+3R9jEOr3Bvv87CrK
         Lz1/CIc8nJW38lp+TN7c2ex59Nm7p6N9pCtwTGrfWQ+5o+bJw3+YfSOgDbtULamJ6RTg
         nx+w==
X-Gm-Message-State: APjAAAXV/yfFxkAyIU6r4e4pvM1bv9Z/f6ROUF147w+LSyzCwf7IB85t
        bA1sYCSzxhN3Zm+I8dI+Uoxz/qClJdQ=
X-Google-Smtp-Source: APXvYqwGY8X1gfGflS2+wOJqfWRCuLhkutccV5+Co708RwxzYg8lK70VWEP4ox1Nk+/mS7aPOnV5SQ==
X-Received: by 2002:a17:902:b612:: with SMTP id b18mr6194352pls.309.1573163171910;
        Thu, 07 Nov 2019 13:46:11 -0800 (PST)
Received: from google.com ([2620:15c:201:2:765b:31cb:30c4:166])
        by smtp.gmail.com with ESMTPSA id k190sm4984717pga.12.2019.11.07.13.46.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 13:46:11 -0800 (PST)
Date:   Thu, 7 Nov 2019 13:46:06 -0800
From:   Eric Biggers <ebiggers@google.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_io: fix memory leak in add_enckey
Message-ID: <20191107214606.GA1160@google.com>
Mail-Followup-To: Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
References: <4eb1073f-91fb-a4bc-aae8-d54dc5a6b8aa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4eb1073f-91fb-a4bc-aae8-d54dc5a6b8aa@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 10:50:59AM -0600, Eric Sandeen wrote:
> Invalid arguments to add_enckey will leak the "arg" allocation,
> so fix that.
> 
> Fixes: ba71de04 ("xfs_io/encrypt: add 'add_enckey' command")
> Fixes-coverity-id: 1454644
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/io/encrypt.c b/io/encrypt.c
> index 17d61cfb..c6a4e190 100644
> --- a/io/encrypt.c
> +++ b/io/encrypt.c
> @@ -696,6 +696,7 @@ add_enckey_f(int argc, char **argv)
>  				goto out;
>  			break;
>  		default:
> +			free(arg);
>  			return command_usage(&add_enckey_cmd);
>  		}
>  	}
> 

The same leak happens later in the function too.  How about this instead:

diff --git a/io/encrypt.c b/io/encrypt.c
index 17d61cfb..de48c50c 100644
--- a/io/encrypt.c
+++ b/io/encrypt.c
@@ -678,6 +678,7 @@ add_enckey_f(int argc, char **argv)
 	int c;
 	struct fscrypt_add_key_arg *arg;
 	ssize_t raw_size;
+	int retval = 0;
 
 	arg = calloc(1, sizeof(*arg) + FSCRYPT_MAX_KEY_SIZE + 1);
 	if (!arg) {
@@ -696,14 +697,17 @@ add_enckey_f(int argc, char **argv)
 				goto out;
 			break;
 		default:
-			return command_usage(&add_enckey_cmd);
+			retval = command_usage(&add_enckey_cmd);
+			goto out;
 		}
 	}
 	argc -= optind;
 	argv += optind;
 
-	if (argc != 0)
-		return command_usage(&add_enckey_cmd);
+	if (argc != 0) {
+		retval = command_usage(&add_enckey_cmd);
+		goto out;
+	}
 
 	raw_size = read_until_limit_or_eof(STDIN_FILENO, arg->raw,
 					   FSCRYPT_MAX_KEY_SIZE + 1);
@@ -732,7 +736,7 @@ add_enckey_f(int argc, char **argv)
 out:
 	memset(arg->raw, 0, FSCRYPT_MAX_KEY_SIZE + 1);
 	free(arg);
-	return 0;
+	return retval;
 }
 
 static int

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1K0eeXH140681 for <xfs@oss.sgi.com>; Thu, 19 Feb 2009 18:40:40 -0600
Received: from rv-out-0506.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C0462136F2A
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2009 16:40:07 -0800 (PST)
Received: from rv-out-0506.google.com (rv-out-0506.google.com
	[209.85.198.236]) by cuda.sgi.com with ESMTP id
	T5gyxLeiOMwtB2rG for <xfs@oss.sgi.com>;
	Thu, 19 Feb 2009 16:40:07 -0800 (PST)
Received: by rv-out-0506.google.com with SMTP id g9so532864rvb.4
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2009 16:40:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <499D0471.6000600@redhat.com>
References: <499D0471.6000600@redhat.com>
Date: Fri, 20 Feb 2009 11:33:13 +1100
Message-ID: <d38e348a0902191633x382e4683scfdc3f07b2f9be03@mail.gmail.com>
Subject: Re: libattr - severe memory leaks from attr_copy_file()
From: Timothy Shimmin <timothy.shimmin@gmail.com>
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
To: Zdenek Prikryl <zprikryl@redhat.com>
Cc: xfs@oss.sgi.com

Hi Zdenek,

On Thu, Feb 19, 2009 at 6:04 PM, Zdenek Prikryl <zprikryl@redhat.com> wrote:
>> And the variable, text, is assigned straight away before any use,
>> so I missed where the problem is.
>>
>> --Tim
>
> The memory leak is really there. Look:
:-)

>
> 54 attr_parse_attr_conf(struct error_context *ctx)
> ...
> 66 repeat:
> 67         text = malloc(size_guess + 1);
> 68         if (!text)
> 69                 goto fail;
> 70
> 71         if ((file = fopen(ATTR_CONF, "r")) == NULL) {
> 72                 if (errno == ENOENT)
> 73                         return 0;
> 74                 goto fail;
> 75         }
>
> Let's say that malloc() on the line 67 success, so we have text != NULL. Then,
> fopen() on the line 71 fails and errno == ENOENT. In that case
> attr_parse_attr_conf() simply returns 0, but text isn't freed. That's the point,
> where memory leaks arise. I rewrote the patch, so now is more simpler.
>
Oh okay.
I see. I was looking at the "fail" case.
Hmmm.... the direct return case.
The simpler patch looks better - cool.

So I now worry about all the cases where we call return directly.
It looks like the code is building up an action list and string dup'ing
patterns.
So in the normal case where it processes them and then returns 0,
I can't see where it is free'ing the text.
Am I missing something again?

My other concern is the free(pattern) and the free(attr_actions->pattern)
with the possibility of trying to free the pattern twice. Probably, could set
pattern to NULL after it is put into the new action or some such.

--Tim


> --
> Zdenek Prikryl <zprikryl@redhat.com>
>
>
> diff -up attr-2.4.43/libattr/attr_copy_action.c.leak attr-2.4.43/libattr/attr_copy_action.c
> --- attr-2.4.43/libattr/attr_copy_action.c.leak 2008-06-30 07:22:50.000000000 +0200
> +++ attr-2.4.43/libattr/attr_copy_action.c      2009-02-17 09:50:38.000000000 +0100
> @@ -53,7 +53,7 @@ free_attr_actions(void)
>  static int
>  attr_parse_attr_conf(struct error_context *ctx)
>  {
> -       char *text, *t;
> +       char *text = NULL, *t;
>        size_t size_guess = 4096, len;
>        FILE *file;
>        char *pattern = NULL;
> @@ -64,15 +64,16 @@ attr_parse_attr_conf(struct error_contex
>                return 0;
>
>  repeat:
> -       text = malloc(size_guess + 1);
> -       if (!text)
> -               goto fail;
> -
>        if ((file = fopen(ATTR_CONF, "r")) == NULL) {
>                if (errno == ENOENT)
>                        return 0;
>                goto fail;
>        }
> +
> +       text = malloc(size_guess + 1);
> +       if (!text)
> +               goto fail;
> +
>        len = fread(text, 1, size_guess, file);
>        if (ferror(file))
>                goto fail;
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

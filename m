Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:53720 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753360AbdKIIkI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2017 03:40:08 -0500
MIME-Version: 1.0
In-Reply-To: <20171109083242.32373-1-eguan@redhat.com>
References: <20171109083242.32373-1-eguan@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 9 Nov 2017 10:40:07 +0200
Message-ID: <CAOQ4uxiNcAyqZtmxNFGHwd0TSs4bRdV8bv8JVrtyFqg5=N=obA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] ltp/fsx: allow comments when reading operations
 from logs
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Nov 9, 2017 at 10:32 AM, Eryu Guan <eguan@redhat.com> wrote:
> We use '--replay-ops' option to replay operations in the specified
> operation log file, but we're not allowed to add comments for the
> operations in the log, which might be useful when writing regression
> tests that replay a given sequence of operations.
>
> Now treat lines starting with '#' as comments and skip them when
> reading operations.
>
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
> v2:
> - no change since v1

Looks fine

>
>  ltp/fsx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/ltp/fsx.c b/ltp/fsx.c
> index 863d536e5a7b..9c358f27bd92 100644
> --- a/ltp/fsx.c
> +++ b/ltp/fsx.c
> @@ -1391,7 +1391,7 @@ read_op(struct log_entry *log_entry)
>                                 goto fail;
>                         }
>                         str = strtok(line, " \t\n");
> -               } while (!str);
> +               } while (!str || str[0] == '#');
>
>                 if (strcmp(str, "skip") == 0) {
>                         log_entry->flags |= FL_SKIPPED;
> --
> 2.13.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

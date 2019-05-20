Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48992 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbfETUIg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 May 2019 16:08:36 -0400
Subject: Re: [PATCH] xfsdump: add a space after commas and semicolons where
 was none
References: <20190517115254.54436-1-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <44e13bbb-40b6-dcd0-9fd2-1243101cffe6@sandeen.net>
Date: Mon, 20 May 2019 15:08:35 -0500
MIME-Version: 1.0
In-Reply-To: <20190517115254.54436-1-jtulak@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org

On 5/17/19 6:52 AM, Jan Tulak wrote:
> @@ -3130,7 +3130,7 @@ static tsi_cmd_tbl_t tsi_cmd_tbl[] = {
>  	{ "cd",		"[ <path> ]",			tsi_cmd_cd,	1, 2 },
>  	{ "add",	"[ <path> ]",			tsi_cmd_add,	1, 2 },
>  	{ "delete",	"[ <path> ]",			tsi_cmd_delete,	1, 2 },
> -	{ "extract",	"",				tsi_cmd_extract,1, 1 },
> +	{ "extract",	"",				tsi_cmd_extract, 1, 1 },
>  	{ "quit",	"",				tsi_cmd_quit,	1, 1 },
>  	{ "help",	"",				tsi_cmd_help,	1, 1 },
>  };

I dropped a couple of hunks like this one, where bending the rules can
actually help readability by keeping things aligned.

Otherwise, looks fine, thanks.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

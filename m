Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54552 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935643AbeE3CJf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 May 2018 22:09:35 -0400
Subject: Re: [PATCH v4 3/4] mkfs.xfs: add configuration file parsing support
 using our own parser
References: <20180529220603.29420-1-mcgrof@kernel.org>
 <20180529220603.29420-4-mcgrof@kernel.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <47de5ed0-443a-0a37-2618-963fb9a46973@sandeen.net>
Date: Tue, 29 May 2018 21:09:33 -0500
MIME-Version: 1.0
In-Reply-To: <20180529220603.29420-4-mcgrof@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com

On 5/29/18 5:06 PM, Luis R. Rodriguez wrote:
> +/*
> + * If the file is not found -1 is returned and errno set. Otherwise
> + * the file descriptor is returned.
> + */
> +int
> +open_cli_config(
> +	char			*cli_config_file,
> +	char			**fpath)
> +{
> +	int			fd, len;
> +	char			*final_path = NULL;
> +	char			*relative_path= NULL;
> +	unsigned int		i;
> +
> +	if (strlen(cli_config_file) > 2) {
> +		if (cli_config_file[0] == '.' && cli_config_file[1] == '/')
> +			final_path = cli_config_file;
> +		else if (cli_config_file[0] == '.' && cli_config_file[1] == '.')
> +			final_path = cli_config_file;
> +		else if (cli_config_file[0] == '/')
> +			final_path = cli_config_file;
> +		else
> +			relative_path = cli_config_file;
> +	} else if (strlen(cli_config_file) == 1) {
> +		if (cli_config_file[0] == '.' || cli_config_file[0] == '/') {
> +			errno = EINVAL;
> +			return -1;
> +		} else
> +			relative_path = cli_config_file;
> +	}

so you have 2 cases, strlen > 2 and strlen == 1.  What about == 2?

# ls /a
/a
# mkfs/mkfs.xfs -c /a /dev/sdb1
Error parsing command line config file: /a : No such device or address

so that looks like a bug here.

-Eric

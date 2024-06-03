Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B8D7BAE5
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 12:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717418989; cv=none; b=AMHunpDMwpuFqlLh1vthBwJ2yUH9vLkknSpvQ9fuYP/QVL1045kXAErqkIDjRCxDA1xD6hD6wsUlgZk4QdJW6qnDKGBKBLZ2DRY9/JpLHWZ0+awCrvO2grSL93qVV+Xj6Agqfh40kb7wCXg1Ju5UcWsLg6IYZXF7A0C2cjSeHow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717418989; c=relaxed/simple;
	bh=qmB158ssDQDBsl72Xzg6xftkU5db/0o5sr1RtXRGUMs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ivkNs74GJF/XDTDuxrOXZ+UaQxP00H0XXXSeDqQytnkQRqN2EZF/wORl6tNGUM6c/oAZS06DkQnoGDq26mG3+rmjxu+uTJZ4a33bHVBsNLXMFIZKAzUUQjFyTrTArs8ay6zJkaFz1x4DB7aMp3pWcTw+WRTr6GeXqBNr8rU9+U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nr4BFwRo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nr4BFwRo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA826C32789;
	Mon,  3 Jun 2024 12:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717418988;
	bh=qmB158ssDQDBsl72Xzg6xftkU5db/0o5sr1RtXRGUMs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nr4BFwRoinR4gHbt3MuyRz1UYi6GKTOfs46yz8jwZJF8QYkVZcXAZITlTLETeig3l
	 9znPNtCQpk6dNrSGC8/49gOIuCOVt/IWNYJbVhCpO9EdtVElcgq0SKLOW6X6acXU0s
	 /smKDm1iSIxkZnd+/SKsA7sXOOxCEEQL35cKCKr2+cFPgZEz4+6IP5OauamKWQYtwS
	 cf2qYpslQqvA9QYRt3UfcW0EiU9mX1LTWu70lJvdVydTXhQLL9tdDN09v5gvHnsUed
	 fFie/mEBS7igbHZekSng8pephNV49iz1V441y2E7mq1mwWaN/6m+usFfr0Xt9QJH26
	 4zFdD8nGLsJDQ==
Date: Mon, 3 Jun 2024 14:49:44 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, 
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_io: print sysfs paths of mounted filesystems
Message-ID: <vtzm5kcbdwdutfrpvyng6xm66fahxnzst2fb53xxn52ph7zbvz@pzcjrvqeo6o2>
References: <1om_d115LQlficlrvs8z5v0InzJMyVDs_WfIJ1ttxO6uOL4FNNGJWtpebpaOoO0MIL7ZUgh7Xm224Eb-aKVaAg==@protonmail.internalid>
 <20240602232949.GZ52987@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240602232949.GZ52987@frogsfrogsfrogs>

On Sun, Jun 02, 2024 at 04:29:49PM GMT, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Enable users to print the sysfs or debugfs path for the filesystems
> backing the open files.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>


Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> ---
>  io/fsuuid.c       |   68 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  man/man8/xfs_io.8 |    7 +++++
>  2 files changed, 75 insertions(+)
> 
> diff --git a/io/fsuuid.c b/io/fsuuid.c
> index af2f87a20209..8e50ec14c8fd 100644
> --- a/io/fsuuid.c
> +++ b/io/fsuuid.c
> @@ -12,6 +12,7 @@
>  #include "libfrog/logging.h"
> 
>  static cmdinfo_t fsuuid_cmd;
> +static cmdinfo_t sysfspath_cmd;
> 
>  static int
>  fsuuid_f(
> @@ -35,6 +36,62 @@ fsuuid_f(
>  	return 0;
>  }
> 
> +#ifndef FS_IOC_GETFSSYSFSPATH
> +struct fs_sysfs_path {
> +	__u8			len;
> +	__u8			name[128];
> +};
> +#define FS_IOC_GETFSSYSFSPATH		_IOR(0x15, 1, struct fs_sysfs_path)
> +#endif
> +
> +static void
> +sysfspath_help(void)
> +{
> +	printf(_(
> +"\n"
> +" print the sysfs path for the open file\n"
> +"\n"
> +" Prints the path in sysfs where one might find information about the\n"
> +" filesystem backing the open files.  The path is not required to exist.\n"
> +" -d	-- return the path in debugfs, if any\n"
> +"\n"));
> +}
> +
> +static int
> +sysfspath_f(
> +	int			argc,
> +	char			**argv)
> +{
> +	struct fs_sysfs_path	path;
> +	bool			debugfs = false;
> +	int			c;
> +	int			ret;
> +
> +	while ((c = getopt(argc, argv, "d")) != EOF) {
> +		switch (c) {
> +		case 'd':
> +			debugfs = true;
> +			break;
> +		default:
> +			exitcode = 1;
> +			return command_usage(&sysfspath_cmd);
> +		}
> +	}
> +
> +	ret = ioctl(file->fd, FS_IOC_GETFSSYSFSPATH, &path);
> +	if (ret) {
> +		xfrog_perror(ret, "FS_IOC_GETSYSFSPATH");
> +		exitcode = 1;
> +		return 0;
> +	}
> +
> +	if (debugfs)
> +		printf("/sys/kernel/debug/%.*s\n", path.len, path.name);
> +	else
> +		printf("/sys/fs/%.*s\n", path.len, path.name);
> +	return 0;
> +}
> +
>  void
>  fsuuid_init(void)
>  {
> @@ -46,4 +103,15 @@ fsuuid_init(void)
>  	fsuuid_cmd.oneline = _("get mounted filesystem UUID");
> 
>  	add_command(&fsuuid_cmd);
> +
> +	sysfspath_cmd.name = "sysfspath";
> +	sysfspath_cmd.cfunc = sysfspath_f;
> +	sysfspath_cmd.argmin = 0;
> +	sysfspath_cmd.argmax = -1;
> +	sysfspath_cmd.args = _("-d");
> +	sysfspath_cmd.flags = CMD_NOMAP_OK | CMD_FLAG_FOREIGN_OK;
> +	sysfspath_cmd.oneline = _("get mounted filesystem sysfs path");
> +	sysfspath_cmd.help = sysfspath_help;
> +
> +	add_command(&sysfspath_cmd);
>  }
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index 56abe000f235..3ce280a75b4a 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -1464,6 +1464,13 @@ flag.
>  .TP
>  .B fsuuid
>  Print the mounted filesystem UUID.
> +.TP
> +.B sysfspath
> +Print the sysfs or debugfs path for the mounted filesystem.
> +
> +The
> +.B -d
> +option selects debugfs instead of sysfs.
> 
> 
>  .SH OTHER COMMANDS
> 

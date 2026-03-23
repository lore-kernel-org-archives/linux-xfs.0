Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF87359A94;
	Mon, 23 Mar 2026 19:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774293885; cv=none; b=ATiVOvqPJGh+yK7p5R+4sWYrwot8pJKv8xVs10coUxNMIDDnK26ii58guqXx0qmSRSQRm1/hwQmjQrP1mPaxsnMdFfXSQ3j4WTDhCNVUkOclnDERId1kd6HGwyJONHIPkM0m+nXtrCvFBrKgpvXrQda5JBlTgAY9Yj/Kc8viAqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774293885; c=relaxed/simple;
	bh=mWyrUOPWTSJoaU6a2GftDk5Ql6QbxVjhOfbP0fwQbSo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=skTEjtcNcSekVmU9/IEjkdjlSe0/Q9brHPhrPm6kj1wBxAwboLueLTcYoiecrclRlCYqkP9UGmtNVocrpiDx/8PefIJwdVspHG7XXB17TDmCld9YuK6LW1r4X1ep5LI1X+triKA9kOyd4mbQdthqNOpx7entjPD1f1/gkJ352bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 803A61B9338;
	Mon, 23 Mar 2026 19:24:36 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf13.hostedemail.com (Postfix) with ESMTPA id 9D4AB2000E;
	Mon, 23 Mar 2026 19:24:34 +0000 (UTC)
Date: Mon, 23 Mar 2026 15:25:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Kees Cook <kees@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
 Andrey Albershteyn <aalbersh@redhat.com>, linux-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] xfs: Replace strncpy() with strscpy_pad() in tracepoint
 error paths
Message-ID: <20260323152514.006d96b5@gandalf.local.home>
In-Reply-To: <20260323172204.work.979-kees@kernel.org>
References: <20260323172204.work.979-kees@kernel.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: a9cubsx3kmcd96hh31jcpi9ngny15qrs
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 9D4AB2000E
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+OA4qXrbdyasYTd1S00snUQyBrAGOfLns=
X-HE-Tag: 1774293874-862539
X-HE-Meta: U2FsdGVkX197dFKfRjDw6D7qzxrvAo285F4xi2NWRnGrXg2E/UuhAl2a2irUJLf+oaxwjIHt2WtVm7MrHt2LYD1vH0xAQrUP4J+C/eS0ACFVcGilPS9/JaQ2UPfApyPIb4onPfcoobRLgnkF3aWhPFiElFi9jW+oEiplmw2K+4y46mz8YPDS+Nzlze57sFPnI9J3PL1YHCNZzXSLc3NZ0gV0Ns7zgKM5BxSkwqq4bfIbGrTjugwYAZ3aQd2lsf+EPCR2iPqdJLjKfmUlf0keGYkEruu/k+4igf43aeWmfeoo5sUBD+N83a692Q+7bBhY/rJrr8Yk4KwQNKarU0nXLpQr/f6W3Afh+HmsgBz2uYpeZ0TmkgplVA==

On Mon, 23 Mar 2026 10:22:09 -0700
Kees Cook <kees@kernel.org> wrote:

> Replace the deprecated[1] strncpy() with strscpy_pad() in the
> xfile_create and xmbuf_create tracepoints.
> 
> Both tracepoints use file_path() to resolve a pathname into
> __entry->pathname (a char[MAXNAMELEN] trace ring buffer field). On
> failure, the error path overwrites the buffer with the string literal
> "(unknown)" via strncpy(). The original strncpy() zero-pads the
> remaining 246 bytes (MAXNAMELEN is 256, "(unknown)" is 10 bytes
> including NUL).
> 
> strscpy_pad() preserves this zero-padding, which matters because the
> destination is a trace ring buffer entry: ring buffer slots are not
> zeroed on allocation, and the raw buffer is readable by userspace via
> tracefs. The zero-padding ensures no stale data remains in the
> buffer after the error path overwrites it.
> 
> The source is a 10-byte string literal into a 256-byte destination,
> so there is no behavioral change.

Hmm, seems to be a lot of waste. Note, the ring buffer now zeros out its
data on allocation so there's no need to zero pad anything, at least not
for exposing data. You may expose a previous trace.

Also, why are these using full path size and not just use dynamic array.
That would be much more efficient in both performance and space.

-- Steve


> 
> Link: https://github.com/KSPP/linux/issues/90 [1]
> Signed-off-by: Kees Cook <kees@kernel.org>
> ---
>  fs/xfs/scrub/trace.h | 3 +--
>  fs/xfs/xfs_trace.h   | 3 +--
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> index 39ea651cbb75..46c420f51129 100644
> --- a/fs/xfs/scrub/trace.h
> +++ b/fs/xfs/scrub/trace.h
> @@ -980,8 +980,7 @@ TRACE_EVENT(xfile_create,
>  		__entry->ino = file_inode(xf->file)->i_ino;
>  		path = file_path(xf->file, __entry->pathname, MAXNAMELEN);
>  		if (IS_ERR(path))
> -			strncpy(__entry->pathname, "(unknown)",
> -					sizeof(__entry->pathname));
> +			strscpy_pad(__entry->pathname, "(unknown)");
>  	),
>  	TP_printk("xfino 0x%lx path '%s'",
>  		  __entry->ino,
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 813e5a9f57eb..9f9fb86097ed 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -5101,8 +5101,7 @@ TRACE_EVENT(xmbuf_create,
>  		__entry->ino = file_inode(file)->i_ino;
>  		path = file_path(file, __entry->pathname, MAXNAMELEN);
>  		if (IS_ERR(path))
> -			strncpy(__entry->pathname, "(unknown)",
> -					sizeof(__entry->pathname));
> +			strscpy_pad(__entry->pathname, "(unknown)");
>  	),
>  	TP_printk("dev %d:%d xmino 0x%lx path '%s'",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),


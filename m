Received: from mail.itouring.de (mail.itouring.de [85.10.202.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3749412BF8
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2026 18:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.10.202.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784054100; cv=none; b=ecNd7p82RhXitowt5X/DZbrnaRK3WAunAYONaYEMlgL9UrC/VZec2ieLEit6SrGSMFfx9PMPh/GoOWNZ7k/89fjYs/LkZrPxQ9uU62gbkfOqiH4x7B5lWCmWNsVnrMHhdzOeY4UEY7UMJYpjMcHCz8hhfqeAu/SeBXGeaMsu3A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784054100; c=relaxed/simple;
	bh=RZLveJ3hnbxCUuQZgmXA8uDUQTMkyNYc/NFUZDzzsu4=;
	h=Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=UWup+OSr6qHyV4a5V3829TZHy7lKTQOHTR6ogjix7g/GDCiuUOiDGfa0LsnaXgodGFrWluerr2a7K/7gtq8Z5y8Pc6yoc2CQoybe7swN+JY5T6rzQ7RPhT6ObZFE4OXgI9pM1f+xW6vKOxas7iTpINkXduoDp5kDTQkU8rONxxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=applied-asynchrony.com; spf=pass smtp.mailfrom=applied-asynchrony.com; arc=none smtp.client-ip=85.10.202.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=applied-asynchrony.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=applied-asynchrony.com
Received: from tux.applied-asynchrony.com (p5ddd7a22.dip0.t-ipconnect.de [93.221.122.34])
	by mail.itouring.de (Postfix) with ESMTPSA id AA61D3BC6;
	Tue, 14 Jul 2026 20:25:02 +0200 (CEST)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
	by tux.applied-asynchrony.com (Postfix) with ESMTP id 78965601893B2;
	Tue, 14 Jul 2026 20:25:01 +0200 (CEST)
Subject: Re: xfsprogs: 7.1.0 Build Failure
To: Reilly Brogan <reilly@reillybrogan.com>, linux-xfs@vger.kernel.org
References: <CABqFQkar-sMMyZGw4KfAV51x7F65ddF7d8cszQ8iWiprvnKMFQ@mail.gmail.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <bf7bab13-51eb-8be8-a875-fd9d02391f51@applied-asynchrony.com>
Date: Tue, 14 Jul 2026 20:25:01 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CABqFQkar-sMMyZGw4KfAV51x7F65ddF7d8cszQ8iWiprvnKMFQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 2026-07-14 19:10, Reilly Brogan wrote:
> We're seeing a build failure on AerynOS with 7.1.0 that we didn't get
> with 7.0.1:
> 
> ```
> Installing healer-install
> ../install-sh -o root -g root -m 755 -d /usr/lib/xfsprogs
> /usr/bin/dash ../libtool --quiet --mode=install ../install-sh -o root
> -g root -m 755 xfs_healer xfs_healer_start /usr/lib/xfsprogs
> Usage: /mason/build/x86_64/xfsprogs-7.1.0.tar.xz/libtool [OPTION]...
> [MODE-ARG]...
> Try 'libtool --help' for more information.
> libtool:   error: '/usr/lib/xfsprogs' is not a directory
> make[1]: *** [Makefile:72: install-healer] Error 1
> ```
> 
> We use slibtool as our libtool implementation and dash as /usr/bin/sh
> so perhaps this is an incompatibility with either of those (likely
> slibtool).

Nope - I see the same on Gentoo with bash and GNU libtool:

Installing scrub-install
gmake[1]: Nothing to be done for 'install'.
../install-sh -o portage -g portage -m 755 -d /usr/libexec/xfsprogs
/bin/sh ../libtool --quiet --mode=install ../install-sh -o portage -g portage -m 755 xfs_healer xfs_healer_start /usr/libexec/xfsprogs
Usage: /tmp/portage/sys-fs/xfsprogs-7.1.0/work/xfsprogs-7.1.0/libtool [OPTION]... [MODE-ARG]...
Try 'libtool --help' for more information.
libtool:   error: '/usr/libexec/xfsprogs' is not a directory
gmake[1]: *** [Makefile:72: install-healer] Error 1
make: *** [Makefile:134: healer-install] Error 2

-h

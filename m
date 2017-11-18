Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:40950 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754699AbdKRTD5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Nov 2017 14:03:57 -0500
MIME-Version: 1.0
In-Reply-To: <20171116184358.475929943@linutronix.de>
References: <20171116183306.103584007@linutronix.de> <20171116184358.475929943@linutronix.de>
From: Charlemagne Lasse <charlemagnelasse@gmail.com>
Date: Sat, 18 Nov 2017 20:03:56 +0100
Message-ID: <CAFGhKbxbW87yowc7trkiczjXV=37SqswwmOriTdSoxCXzFk-0A@mail.gmail.com>
Subject: Re: [patch V2 02/11] LICENSES: Add the GPL 2.0 license
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kstewart@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org, Carmen Bianca Bakker <carmenbianca@fsfe.org>

2017-11-16 19:33 GMT+01:00 Thomas Gleixner <tglx@linutronix.de>:
> Add the full text of the GPL 2.0 license to the kernel tree.  It was
> copied directly from:
>
>    https://spdx.org/licenses/GPL-2.0.html#licenseText
>
> Add the required tags for reference and tooling.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

NACKed-by: Charlemagne Lasse <charlemagnelasse@gmail.com>

This is neither the GPL-2.0 from https://www.gnu.org/licenses/gpl-2.0.txt
(which you should have used) or
https://spdx.org/licenses/GPL-2.0.html#licenseText

Please download the correct ASCII version from gnu.org and add your SPDX
info in front of it. But I have also added detailed info about
non-whitespace changes in your patch.

But I am sure that you will tell me again that I am only arguing in
circles.

>
> ---
>  LICENSES/preferred/GPL-2.0 |  348 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 348 insertions(+)
>  create mode 100644 LICENSES/GPL-2.0

This patch seems to have been modified by hand because the summary doesn't
match the patch.

>
> --- /dev/null
> +++ b/LICENSES/preferred/GPL-2.0
<cut>
> +GNU GENERAL PUBLIC LICENSE
> +Version 2, June 1991
> +
> +Copyright (C) 1989, 1991 Free Software Foundation, Inc.

That should be:  "Inc.," and not "Inc."

<cut>
> +
> +Everyone is permitted to copy and distribute verbatim copies
> +of this license document, but changing it is not allowed.
> +
> +Preamble
> +
> +The licenses for most software are designed to take away your freedom to
> +share and change it. By contrast, the GNU General Public License is
> +intended to guarantee your freedom to share and change free software--to
> +make sure the software is free for all its users. This General Public
> +License applies to most of the Free Software Foundation's software and to
> +any other program whose authors commit to using it. (Some other Free
> +Software Foundation software is covered by the GNU Library General Public
> +License instead.) You can apply it to your programs, too.

That should be "GNU Lesser General Public" and not "GNU Library General Public"

<cut>
> +The precise terms and conditions for copying, distribution and modification follow.
> +
> +TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

"GNU GENERAL PUBLIC LICENSE" is missing before
"TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION"

<cut>
> +To do so, attach the following notices to the program. It is safest to
> +attach them to the start of each source file to most effectively convey the
> +exclusion of warranty; and each file should have at least the "copyright"
> +line and a pointer to where the full notice is found.
> +
> +    One line to give the program's name and a brief idea of what it does.

This should actually be:

<one line to give the program's name and a brief idea of what it does.>


> +    Copyright (C) <year> <name of author>
> +
> +    This program is free software; you can redistribute it and/or modify it
> +    under the terms of the GNU General Public License as published by the
> +    Free Software Foundation; either version 2 of the License, or (at your
> +    option) any later version.
> +
> +    This program is distributed in the hope that it will be useful, but
> +    WITHOUT ANY WARRANTY; without even the implied warranty of
> +    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
> +    General Public License for more details.
> +
> +    You should have received a copy of the GNU General Public License along
> +    with this program; if not, write to the Free Software Foundation, Inc.,
> +    59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

This is the wrong address. It should actually be

51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

<cut>
> +    Yoyodyne, Inc., hereby disclaims all copyright interest in the program
> +    `Gnomovision' (which makes passes at compilers) written by James
> +    Hacker.
> +
> +    signature of Ty Coon, 1 April 1989

This should actually be:

<signature of Ty Coon>, 1 April 1989


> +    Ty Coon, President of Vice
> +
> +This General Public License does not permit incorporating your program into
> +proprietary programs. If your program is a subroutine library, you may
> +consider it more useful to permit linking proprietary applications with the
> +library. If this is what you want to do, use the GNU Library General Public
> +License instead of this License.

"Lesser Library General Public" and not "Library General Public License"

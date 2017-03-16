Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56230 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751547AbdCPRMc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Mar 2017 13:12:32 -0400
Subject: Re: [PATCH 04/22] mkfs: change conflicts array into a table capable
 of cross-option addressing
References: <20170315160017.27805-1-jtulak@redhat.com>
 <20170315160017.27805-5-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <406aa194-3df0-d895-c0bf-db424343db99@sandeen.net>
Date: Thu, 16 Mar 2017 10:02:54 -0700
MIME-Version: 1.0
In-Reply-To: <20170315160017.27805-5-jtulak@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org

On 3/15/17 8:59 AM, Jan Tulak wrote:
> Change subopt_param.conflicts from array of integers into array of structures.
> This prepares the ground for more universal conflict detection in future
> patches.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> ---
>  mkfs/xfs_mkfs.c | 243 ++++++++++++++++++++++++++++++--------------------------
>  1 file changed, 129 insertions(+), 114 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 5e15fee2..c9861409 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -93,8 +93,16 @@ unsigned int		sectorsize;
>   *
>   *   conflicts MANDATORY
>   *     If your subopt is in a conflict with some other option, specify it.
> - *     Accepts the .index values of the conflicting subopts and the last
> - *     member of this list has to be LAST_CONFLICT.
> + *     Accepts the .index values of the conflicting subopt as .opt (e.g. OPT_D)
> + *     and .subopt (e.g. D_FILE). If .test_values is true, then the conflict
> + *     is raised only when the "remote" suboption .value is equal to
> + *     .invalid_value field and the "current" suboption has .value equal to
> + *     .at_value.
> + *     If .test_values is false, a conflict is raised when the suboption appears
> + *     on the CLI, no matter its value. The field .message contains an optional
> + *     explanatory string for the user. This string can't be translated here,
> + *     so it has to be enveloped with _() when printed.

You also still need to mark each string initializer you added in the array
in patch 08 with N_(" ... ") or gettext won't know about it. 
(I think that's the right way to go about it)

-Eric

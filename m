Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43226 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbfGUQns (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 21 Jul 2019 12:43:48 -0400
Date: Mon, 22 Jul 2019 00:43:38 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH v4 2/3] generic: copy_file_range bounds test
Message-ID: <20190721164338.GJ7943@desktop>
References: <20190715125516.7367-1-amir73il@gmail.com>
 <20190715125516.7367-3-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190715125516.7367-3-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Olga Kornievskaia <olga.kornievskaia@gmail.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On Mon, Jul 15, 2019 at 03:55:15PM +0300, Amir Goldstein wrote:
> Test that copy_file_range will return the correct errors for various
> error conditions and boundary constraints.
> 
> This is a regression test for kernel commit:
> 
>   5dae222a5ff0 vfs: allow copy_file_range to copy across devices

This seems like refering to the wrong commit, I've changed it to

96e6e8f4a68d ("vfs: add missing checks to copy_file_range")

Thanks,
Eryu

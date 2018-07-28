Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49162 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388735AbeG1Bql (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 27 Jul 2018 21:46:41 -0400
Subject: Re: [PATCH] xfs: add debian initramfs hook to package
From: Eric Sandeen <sandeen@sandeen.net>
References: <20180726215154.GI30972@magnolia>
 <f2b317ec-3541-4441-cf11-58602eb8de4f@sandeen.net>
Message-ID: <af4d254e-599d-7756-24ba-8c44254befae@sandeen.net>
Date: Fri, 27 Jul 2018 17:22:21 -0700
MIME-Version: 1.0
In-Reply-To: <f2b317ec-3541-4441-cf11-58602eb8de4f@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On 7/27/18 5:13 PM, Eric Sandeen wrote:

> Actually... this sort of fstab poses a problem for your function and mine:
> 
> #/dev/mapper/vg-lv_root /                      xfs    defaults        1 1
> /dev/mapper/vg-lv_root /                       ext4    defaults        1 1

As would this:

# / on zfs won't work, use ext4:
/dev/sda2	/	ext4	defaults	1 1

... anyway, regardless of likelihood need to filter out comments I think.

Thanks,
-Eric

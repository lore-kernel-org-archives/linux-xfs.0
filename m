Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55540 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750975AbdIEKqn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 5 Sep 2017 06:46:43 -0400
Date: Tue, 5 Sep 2017 18:46:41 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2 07/14] fsx: add optional logid prefix to log messages
Message-ID: <20170905104641.GA8034@eguan.usersys.redhat.com>
References: <1504104706-11965-1-git-send-email-amir73il@gmail.com>
 <1504104706-11965-8-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1504104706-11965-8-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Josef Bacik <jbacik@fb.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Wed, Aug 30, 2017 at 05:51:39PM +0300, Amir Goldstein wrote:
> When writing the intermixed output of several fsx processes
> to a single log file, it is usefull to prefix logs with a log id.
> Use fsx -j <logid> to define the log messages prefix.

Would it be better to allow any string as prefix, not limit to id
number?

Thanks,
Eryu

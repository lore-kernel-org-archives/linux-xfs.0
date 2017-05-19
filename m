Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39434 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751406AbdESLMH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 May 2017 07:12:07 -0400
Date: Fri, 19 May 2017 07:12:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfs delayed logging
Message-ID: <20170519111204.GA64091@bfoster.bfoster>
References: <b11cf7a2175672631380d44321d77169@klunky.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b11cf7a2175672631380d44321d77169@klunky.co.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sophie Loewenthal <sophie@klunky.co.uk>
Cc: linux-xfs@vger.kernel.org

On Fri, May 19, 2017 at 11:43:23AM +0200, Sophie Loewenthal wrote:
> 
> Hi,
> 
> Is this mount option implemented and what is the syntax?
> 
> Reference:
> https://www.kernel.org/doc/Documentation/filesystems/xfs-delayed-logging-design.txt
> 

Delayed logging is core infrastructure and thus has been enabled by
default for quite some time now. The associated mount options had been
deprecated and ultimately removed in the following patch:

commit 93b8a5854f247138e401471a9c3b82ccb62ff608
Author: Christoph Hellwig <hch@infradead.org>
Date:   Tue Dec 6 21:58:07 2011 +0000

    xfs: remove the deprecated nodelaylog option
...

Brian

> Kind regards, Sophie
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

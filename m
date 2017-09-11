Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3.molgen.mpg.de ([141.14.17.11]:38429 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751153AbdIKOuO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Sep 2017 10:50:14 -0400
Subject: Re: [PATCH] iomap: fix integer truncation issues in the zeroing and
 dirtying helpers
References: <20170811151805.22896-1-hch@lst.de>
 <f4d52f4d8b1cb6dfb91acaa8612d4bba@molgen.mpg.de>
 <20170813090855.GA32112@lst.de>
From: Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <34a29739-2f5b-a197-d047-e23be17b5086@molgen.mpg.de>
Date: Mon, 11 Sep 2017 16:50:12 +0200
MIME-Version: 1.0
In-Reply-To: <20170813090855.GA32112@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, stockhausen@collogia.de, it+linux-nfs@molgen.mpg.de

Dear Christoph,


On 08/13/17 11:08, Christoph Hellwig wrote:

> I'm overdue doing another XFS stable backport batch, and I will
> include this patch.

If I am not mistaken, this has not been picked up yet for the stable series.

```
$ git tag --contains e28ae8e428fefe2facd72cea9f29906ecb9c861d
v4.13
v4.13-rc6
v4.13-rc7
v4.13.1
$ git log --grep e28ae8e428fefe2facd72cea9f29906ecb9c861d v4.9.48
$
```

Do you want me to submit it for inclusion?


Kind regards,

Paul

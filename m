Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:55080 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751897AbdEVStX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 May 2017 14:49:23 -0400
Message-ID: <1495478957.6967.69.camel@linux.intel.com>
Subject: Re: [PATCH 10/23] afs: switch to use uuid_t and uuid_gen
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Mon, 22 May 2017 21:49:17 +0300
In-Reply-To: <20170518062705.25902-11-hch@lst.de>
References: <20170518062705.25902-1-hch@lst.de>
         <20170518062705.25902-11-hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org

On Thu, 2017-05-18 at 08:26 +0200, Christoph Hellwig wrote:

Changelog?

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: David Howells <dhowells@redhat.com>

> @@ -453,7 +453,7 @@ static int afs_deliver_cb_probe(struct afs_call
> *call)
>  static void SRXAFSCB_ProbeUuid(struct work_struct *work)
>  {
>  	struct afs_call *call = container_of(work, struct afs_call,
> work);
> -	struct uuid_v1 *r = call->request;
> +	uuid_t *r = call->request;
>  
>  	struct {
>  		__be32	match;
> 

Just to double check that this doesn't create a union aliasing.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

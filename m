Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:34313 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752844AbdHNLgY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Aug 2017 07:36:24 -0400
Received: by mail-wr0-f180.google.com with SMTP id l9so10903337wrl.1
        for <linux-xfs@vger.kernel.org>; Mon, 14 Aug 2017 04:36:23 -0700 (PDT)
Received: from hades.localdomain (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id 89sm225935wrj.24.2017.08.14.04.36.21
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 14 Aug 2017 04:36:21 -0700 (PDT)
Date: Mon, 14 Aug 2017 13:36:19 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] Stop searching for free slots in an inode chunk when
 there are none
Message-ID: <20170814113619.dw3mrxrglmgmyl6l@hades.localdomain>
References: <20170814105349.12391-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170814105349.12391-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

I do apologize for forgetting to update the subject before sending it, this is
the 3rd version of this patch

> 
> 	V3: - Move searchdistance state saving out of the while loop
> 	    - Remove newino goto label
> 
> 	V2: - Use searchdistance variable to stop the infinite loop
> 	      instead of adding a new mechanism
> 

-- 
Carlos

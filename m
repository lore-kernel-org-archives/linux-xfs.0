Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1281EB64DA
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Jul 2023 14:24:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbjGDOYS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Jul 2023 10:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbjGDOYR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jul 2023 10:24:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25AEE54
        for <linux-xfs@vger.kernel.org>; Tue,  4 Jul 2023 07:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688480615;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=57AtHpZhcPpEHLsInIfUqM25aW9rcqFnYP6msW9agQ0=;
        b=VEJwKLZCDa8So+eN8or9y3kzPJcKgfAl8/wkQZcJ9Z6P2Vz+U21IQW4t1c6OBmz3WaQ4Ki
        HyAcFR+3yNrmilFbtp4iY9AiKOxwTBFtDy/Ttw6cTxqLN6wKuZGzmvKkKpBXHZJBbTNOkT
        hVKrfPc+Ep3Xmil/Ex95M0Jeweaopxg=
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
 [209.85.222.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-510-7WfzYCdZNhGWeWd64usBFA-1; Tue, 04 Jul 2023 10:23:34 -0400
X-MC-Unique: 7WfzYCdZNhGWeWd64usBFA-1
Received: by mail-ua1-f70.google.com with SMTP id a1e0cc1a2514c-794c8621562so316498241.1
        for <linux-xfs@vger.kernel.org>; Tue, 04 Jul 2023 07:23:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688480614; x=1691072614;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=57AtHpZhcPpEHLsInIfUqM25aW9rcqFnYP6msW9agQ0=;
        b=S8heIFU2ZMEh7PZAl/UhEWvdsGgMeFiHEpvVpmKcMQBrtCyy1MmHq0jIXQvYGfVgIC
         a15XHdKxZ6jvH40SySbFwzeznF+IYmcI4X7UOssTqx7osMYARiGQGvSqrwQbDBpjEzJo
         8O46IbnKFl1KL6lj3SeZX1xY+hA9GVKgIfmL8EHWS5OLd/S/VRYi2lVw1A9JugVMrn06
         picQulVAcjppBEi3hOgjh60vEBBkv2bWzKh4YH8SZ4k0g5Sd/l50P0Sv5mSFaLX0xfZV
         5jzjgkVwoV7khI5OCpHED9ETqUKBLRbyF/ZyI8OHiFLx7F3RDyZc7fD38/IHVBvV28Wh
         C5Aw==
X-Gm-Message-State: ABy/qLZ/RgaDlJYKev8sD2koxc+OucsQL0dPxn8VDU9Agrjkl/Jcq62B
        7KRwPZ6ivOP0eDqdVFdIEuQto36J2xgUP5KBiLzkhLOO+CU7Ij2zwmtEeEhhm5QTa5JrRHqiAIA
        TSF309nCQGlpWkd/jiOF1JZNTl0I=
X-Received: by 2002:a67:fc19:0:b0:443:5927:d41b with SMTP id o25-20020a67fc19000000b004435927d41bmr6292384vsq.31.1688480614158;
        Tue, 04 Jul 2023 07:23:34 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFi7K6KdJZH2Fogg+A4zdTj9t10jEJx5femfLaZvfwZ3GO87oJ8A4Oinbz+v+OGm1najWGnMA==
X-Received: by 2002:a67:fc19:0:b0:443:5927:d41b with SMTP id o25-20020a67fc19000000b004435927d41bmr6292376vsq.31.1688480613925;
        Tue, 04 Jul 2023 07:23:33 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id z26-20020ac83e1a000000b003f7a54fa72fsm1496655qtf.0.2023.07.04.07.23.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jul 2023 07:23:33 -0700 (PDT)
Date:   Tue, 4 Jul 2023 16:23:30 +0200
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 5/5] xfs: test growfs of the realtime device
Message-ID: <20230704142330.7svxnzrdgdys2x5x@aalbersh.remote.csb>
References: <168840381298.1317961.1436890061506567407.stgit@frogsfrogsfrogs>
 <168840384128.1317961.1554188648447496379.stgit@frogsfrogsfrogs>
 <20230704140357.tg2yxfknkzniotve@aalbersh.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230704140357.tg2yxfknkzniotve@aalbersh.remote.csb>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

oh those are from 041, haven't noticed

-- 
- Andrey


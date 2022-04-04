Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 719C0C433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Apr 2022 23:31:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbiDDXdH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Apr 2022 19:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiDDXdG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Apr 2022 19:33:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 93B624C419
        for <linux-xfs@vger.kernel.org>; Mon,  4 Apr 2022 16:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649115067;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=asXDyt09GLTplN7m93x8ujIZL7wyJ2Hz+SDX0MCQqKo=;
        b=Xy+HNX9zGWNbb6TN4rnZ7ndiVrgZ2bcBREM/ZyJESqubZE8JAok9Xv0R9sGtTIXk67xTJM
        O7g35lVFA0FweI5021BTdkuwfd5akxgE+93qcgkvcx57/myu9daVWLHrrinpsUgz8Ymb/T
        DVrsalsh/N6U8FTvMnAeMFNGtraro7Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-145-BCgJ4MDNOG2K847jvZmWsw-1; Mon, 04 Apr 2022 19:31:04 -0400
X-MC-Unique: BCgJ4MDNOG2K847jvZmWsw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B964E80159B;
        Mon,  4 Apr 2022 23:31:03 +0000 (UTC)
Received: from [127.0.0.1] (ovpn04.gateway.prod.ext.rdu2.redhat.com [10.11.146.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 960D1145BEEC;
        Mon,  4 Apr 2022 23:31:03 +0000 (UTC)
Message-ID: <ac764fd9-ddd9-3b44-02bc-c91c390881c5@redhat.com>
Date:   Mon, 4 Apr 2022 18:31:03 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Content-Language: en-US
From:   Eric Sandeen <esandeen@redhat.com>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>
References: <a8bc42f2-98db-2f16-2879-9ed62415ba01@redhat.com>
Reply-To: sandeen@redhat.com
Subject: Re: [PATCH V2] mkfs: increase the minimum log size to 64MB when
 possible
In-Reply-To: <a8bc42f2-98db-2f16-2879-9ed62415ba01@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

For starters I know the lack of if / else if in the co is a little
ugly but smashing into 80cols was uglier...

Here are the changes in log size for various filesystem geometries
(differing block sizes and filesystem sizes, with and without stripe
geometry to increase AG count). "--" means mkfs failed.

Blocksize: 4096
	|	orig		|	new
size	|	log	striped	|	log	striped
-------------------------------------------------------
128m	|	5m	m	|	5m	m
256m	|	5m	18m	|	5m	18m
511m	|	5m	18m	|	5m	18m
512m	|	5m	18m	|	64m	18m
513m	|	5m	18m	|	64m	64m
1024m	|	10m	18m	|	64m	64m
2047m	|	10m	18m	|	64m	64m
2048m	|	10m	18m	|	64m	64m
2049m	|	10m	18m	|	64m	64m
4g	|	10m	20m	|	64m	64m
8g	|	10m	20m	|	64m	64m
15g	|	10m	20m	|	64m	64m
16g	|	10m	20m	|	64m	64m
17g	|	10m	20m	|	64m	64m
32g	|	16m	20m	|	64m	64m
64g	|	32m	32m	|	64m	64m
256g	|	128m	128m	|	128m	128m
512g	|	256m	256m	|	256m	256m
1t	|	512m	512m	|	512m	512m
2t	|	1024m	1024m	|	1024m	1024m
4t	|	2038m	2038m	|	2038m	2038m
8t	|	2038m	2038m	|	2038m	2038m

Blocksize: 1024
	|	orig		|	new
size	|	log	striped	|	log	striped
------------------------------------------------------------------------------
128m	|	3m	15m	|	3m	15m
256m	|	3m	15m	|	3m	15m
511m	|	3m	15m	|	3m	15m
512m	|	3m	15m	|	64m	15m
513m	|	3m	15m	|	64m	64m
1024m	|	10m	15m	|	64m	64m
2047m	|	10m	16m	|	64m	64m
2048m	|	10m	16m	|	64m	64m
2049m	|	10m	16m	|	64m	64m
4g	|	10m	16m	|	64m	64m
8g	|	10m	16m	|	64m	64m
15g	|	10m	16m	|	64m	64m
16g	|	10m	16m	|	64m	64m
17g	|	10m	16m	|	64m	64m
32g	|	16m	16m	|	64m	64m
64g	|	32m	32m	|	64m	64m
256g	|	128m	128m	|	128m	128m
512g	|	256m	256m	|	256m	256m
1t	|	512m	512m	|	512m	512m
2t	|	1024m	1024m	|	1024m	1024m
4t	|	1024m	1024m	|	1024m	1024m
8t	|	1024m	1024m	|	1024m	1024m

Blocksize: 65536
	|	orig		|	new
size	|	log	striped	|	log	striped
------------------------------------------------------------------------------
128m	|	--	--	|	--	--
256m	|	32m	--	|	32m	--
511m	|	32m	32m	|	32m	32m
512m	|	32m	32m	|	64m	32m
513m	|	32m	32m	|	64m	63m
1024m	|	32m	32m	|	64m	64m
2047m	|	56m	45m	|	64m	64m
2048m	|	56m	45m	|	64m	64m
2049m	|	56m	45m	|	64m	64m
4g	|	56m	69m	|	64m	69m
8g	|	56m	69m	|	64m	69m
15g	|	56m	69m	|	64m	69m
16g	|	56m	69m	|	64m	69m
17g	|	56m	69m	|	64m	69m
32g	|	56m	69m	|	64m	69m
64g	|	56m	69m	|	64m	69m
256g	|	128m	128m	|	128m	128m
512g	|	256m	256m	|	256m	256m
1t	|	512m	512m	|	512m	512m
2t	|	1024m	1024m	|	1024m	1024m
4t	|	2038m	2038m	|	2038m	2038m
8t	|	2038m	2038m	|	2038m	2038m


Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr001msb.fastweb.it ([85.18.95.85]:41730 "EHLO
        mr001msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751561AbdHSQkD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 19 Aug 2017 12:40:03 -0400
Subject: Re: Estimate =?UTF-8?Q?xfs=5Frepair=20run=20time?=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sat, 19 Aug 2017 18:39:58 +0200
From: Gionatan Danti <g.danti@assyoma.it>
In-Reply-To: <20170819162025.GT4796@magnolia>
References: <22ed5cf73260ae39bf59779b302d8ad3@assyoma.it>
 <d80ca25cd28ec433c39a7d7d22c4e371@assyoma.it>
 <20170819154804.GS4796@magnolia>
 <3fcdaa5ea4365a1ddb7c76070236e6b3@assyoma.it>
 <20170819162025.GT4796@magnolia>
Message-ID: <a42886b91433dcf4d7fdd3f541f2374a@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, g.danti@assyoma.it

Il 19-08-2017 18:20 Darrick J. Wong ha scritto:
> I meant the per-inode extent size hint.  See 'extsize' in the xfs_io 
> manpage.

I did not know about per-file extent hint. Thank you very much for 
pointing me that!

> {yes, yes, depends on which spindle(s) metadata end up on and how many
> files cross AGs} in that order. :)

Mmm ok, as expected :)
Do you have any direct experience of xfs_repair run times on big and 
full XFS filesystems?

Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8

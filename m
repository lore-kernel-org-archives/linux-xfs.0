Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26BF7C48BDF
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Jun 2021 15:23:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E4D661613
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Jun 2021 15:23:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbhFOPZ4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Jun 2021 11:25:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:35356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230431AbhFOPZz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 15 Jun 2021 11:25:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BABB61603;
        Tue, 15 Jun 2021 15:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623770631;
        bh=+YG3BY8MFRbs1h5W1QgQ/SVbu2aPq9tQrhoNErUDwd8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CPxj18RsnEDoqjaxa/4MqdHzLIVzVsaXVJ3YkhpH7BPnJhtDYQEfEd96LqAFEAtcB
         SUNPvPhIfID99Fb3v4fT7kS7+KgA9CUKyvUlUx0eVjOLZvvLOf+5fP7H/FRdm0pNPu
         sktW9apiJl8h/il9Q8Caycqa8k3oXndMlvhcIY5PNd+/9drJzdh/zDrlDfjM7WsXEe
         9h5B651mF2Kf8kCdHovQHVsioe5YzZv/tTXnMN+GW8lAf0N3+d4F63BLKZaRKIFoOc
         5BElTBBZRSO0qXGv3oqixH4bgMnKoDyPeyQkK0H/gclVqtYIViohvrPZq7c7PVc1Wc
         ALBXMMj23rPvQ==
Date:   Tue, 15 Jun 2021 08:23:50 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Ralf =?iso-8859-1?Q?Gro=DF?= <ralf.gross+xfs@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: copy / move reflink files to new filesystem / or whole fs
Message-ID: <20210615152350.GA158209@locust>
References: <CANSSxykVgGj5PHzfPm_xvJi_dpooS_vBpO14-S3KhM6BZfBFtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANSSxykVgGj5PHzfPm_xvJi_dpooS_vBpO14-S3KhM6BZfBFtA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 15, 2021 at 07:45:59AM +0200, Ralf Groß wrote:
> Hi,
> 
> is there any way to copy or move data between 2 xfs fs with reflinks
> on the same host, so that the data is not rehydrated (I guess cp
> --reflink will not be working)? If this is not possible, would it be
> able to clone the existing fs to a new one and then continue to use
> both?
>
> Background: I've backup data on a 350 TB reflink xfs fs, now a second
> fs will be added to the server and parts of existing data should be
> moved to it. If it's possible to clone the whole fs I could delete
> parts of it afterwards, but copying/moving single directories would be
> easier.

Reflinking (aka data block sharing) can only be performed between files
within a single filesystem.  You could use xfs_copy to clone the fs
which would be faster than dd, though not as fast as targeted copying of
parts of the directory tree as needed.

--D

> 
> Ralf

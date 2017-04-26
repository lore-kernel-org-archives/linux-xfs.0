Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:59874 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752294AbdDZEJi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Apr 2017 00:09:38 -0400
Subject: Re: [PATCH 04/12] mkfs: merge tables for opts parsing into one table
References: <20170423185503.31415-1-jtulak@redhat.com>
 <20170423185503.31415-5-jtulak@redhat.com>
 <f106f9ca-54c7-dcaa-08f4-75b3b086138c@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <cec9cb4e-8af0-ad57-c179-d25d4c916809@sandeen.net>
Date: Tue, 25 Apr 2017 23:09:36 -0500
MIME-Version: 1.0
In-Reply-To: <f106f9ca-54c7-dcaa-08f4-75b3b086138c@sandeen.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org

On 4/25/17 4:45 PM, Eric Sandeen wrote:
> and making sure there's never a mismatch between the case value and the
> value passed to getnum, you could do something like:
> 
>     int so = getsubopt(&p, subopts, &value);
> 
>     switch (so) {
>     case OPT1:
>             opt1 = getnum(value, &opts, so);
>     case OPT2:
>             opt2 = getnum(value, &opts, so);

(but not "so" - not sure why I typed that.  Perhaps "subopt")

-Eric

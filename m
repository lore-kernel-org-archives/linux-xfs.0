Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43806 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725909AbeLEE44 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Dec 2018 23:56:56 -0500
Subject: Re: [PATCH] xfsdump: don't fail installation if /sbin is symlink of
 /usr/sbin
From: Eric Sandeen <sandeen@sandeen.net>
References: <20181101104732.19322-1-jtulak@redhat.com>
 <1a662234-f71a-7208-76f9-9f2f89aa8255@sandeen.net>
Message-ID: <c9bea20c-058c-d715-8b2b-9ac55e77c131@sandeen.net>
Date: Tue, 4 Dec 2018 22:56:55 -0600
MIME-Version: 1.0
In-Reply-To: <1a662234-f71a-7208-76f9-9f2f89aa8255@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org

On 12/4/18 10:48 PM, Eric Sandeen wrote:
> On 11/1/18 5:47 AM, Jan Tulak wrote:
>> Some distributions, like Fedora, have /bin and /sbin as symlinks
>> pointing to /usr/* and this patch adds compatibility for these cases.
> 
> xfsdump builds fine on Fedora, but only because somebody (me) was
> bad long long ago, in the spec file:
> 
> # Bit of a hack to move files from /sbin to /usr/sbin
> (cd $RPM_BUILD_ROOT/%{_sbindir}; rm xfsdump xfsrestore)
> (cd $RPM_BUILD_ROOT/%{_sbindir}; mv ../../sbin/xfsdump .)
> (cd $RPM_BUILD_ROOT/%{_sbindir}; mv ../../sbin/xfsrestore .)
> 
> I ... don't know why that was done.  Seems like dump/restore /should/
> just live in /sbin, no?  I'm not sure what the symlink is/was for
> in the first place...
> 
> but I guess Debian does package it up that way:
> 
> # dpkg-query -L xfsdump | grep xfsrestore | xargs ls -l
> -rwxr-xr-x 1 root root 246088 Aug  1  2014 /sbin/xfsrestore
> lrwxrwxrwx 1 root root     16 Aug  1  2014 /usr/sbin/xfsrestore -> /sbin/xfsrestore
> 
> so, um, I guess this seems ok to handle the /sbin == /usr/sbin case.
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Heh, ok, yes your fix is what I should have done 6 years ago :D

Thanks,
-Eric

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from walrus.jabberwocky.com ([173.9.29.57]:48625 "EHLO
        mail.jabberwocky.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933435AbdDGQ4u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Apr 2017 12:56:50 -0400
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: Processes stuck in D state when accessing XFSv5 filesystem
From: David Shaw <dshaw@jabberwocky.com>
In-Reply-To: <20170407165616.2269260a@harpe.intellique.com>
Date: Fri, 7 Apr 2017 12:56:48 -0400
Content-Transfer-Encoding: 8BIT
Message-Id: <CC0DA53B-D439-476E-AEEE-44951FE8B69C@jabberwocky.com>
References: <C1597D74-938F-4236-91F0-4CA1D6907F50@jabberwocky.com>
 <20170407165616.2269260a@harpe.intellique.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: linux-xfs@vger.kernel.org

On Apr 7, 2017, at 10:56 AM, Emmanuel Florac <eflorac@intellique.com> wrote:
> 
> Le Thu, 6 Apr 2017 14:41:45 -0400
> David Shaw <dshaw@jabberwocky.com> écrivait:
> 
>> I'm having a problem with processes getting "stuck" when accessing an
>> XFS (v5) filesystem.  When it happens, I start getting the "blocked
>> for more than 120 seconds" error, and the process stays in that state
>> until I reboot.  The kernel is 3.10.0-514.2.2 and the xfsprogs is
>> 4.5.0-9 (both Centos 7.3).
>> 
> 
> Could it be that your system is under high IO load?

It's possible that the problem is instigated or made worse by high load, but once the processes enter D state, they stay there even when the system is idle.  They stay in D state until I reboot.

David


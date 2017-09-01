Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f176.google.com ([209.85.128.176]:35395 "EHLO
        mail-wr0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751607AbdIALi5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Sep 2017 07:38:57 -0400
Received: by mail-wr0-f176.google.com with SMTP id y15so5842204wrc.2
        for <linux-xfs@vger.kernel.org>; Fri, 01 Sep 2017 04:38:56 -0700 (PDT)
Date: Fri, 1 Sep 2017 13:38:53 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: How do I stop the roll backs?
Message-ID: <20170901113853.27txrjvdcnc7gcgb@hades.localdomain>
References: <15e3d125e44.1006338d5356.4004547008347294090@zoho.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15e3d125e44.1006338d5356.4004547008347294090@zoho.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: toddandmargo <toddandmargo@zoho.com>
Cc: linux-xfs@vger.kernel.org

Hi,

On Fri, Sep 01, 2017 at 03:52:47AM -0700, toddandmargo wrote:
> Hi All,
> 
> Fedora 26
> 
> Every time I shutdown, everything i have modifies or added  gets rolled back.
> And I have to restore everything from backup, including most of the customer's
> data that was copied from Samba on the old server.  It is a disaster.
> 

This is quite weird, are you able to reproduce it by just
mounting/modifying/unmounting the filesystem?

Only thing that comes to my mind at a first glance would be if something went
wrong with the journal.

Can you provide more details about your setup? Mainly regarding the storage
organization where your XFS filesystem is in. Logs, from the system too.

A good guide of what information to provide can be found here:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F


> How do I stop this?
> 
> Many thanks,
> -T
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos

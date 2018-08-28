Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f43.google.com ([209.85.221.43]:37504 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbeH1Lph (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Aug 2018 07:45:37 -0400
Received: by mail-wr1-f43.google.com with SMTP id u12-v6so608215wrr.4
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 00:54:23 -0700 (PDT)
Date: Tue, 28 Aug 2018 09:54:20 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: Trying to write to read-only block-device from XFS
Message-ID: <20180828075420.5zcww22du3kqkvmq@odin.usersys.redhat.com>
References: <20180824233756.kkvmkmm5mdlx77je@two.firstfloor.org>
 <a4d32107-abc0-60d3-8306-b091fbffefd8@sandeen.net>
 <20180825140951.a3dsz3efwnjsj2pz@two.firstfloor.org>
 <c6bcbef0-0c5b-a7a1-adb6-38085db98ce9@sandeen.net>
 <20180827081254.zat4lvxqviwgd4zn@odin.usersys.redhat.com>
 <20180827164342.4vlg3zaehkzcj6od@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180827164342.4vlg3zaehkzcj6od@two.firstfloor.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andi Kleen <andi@firstfloor.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

> 
> Ok, so the blame is assigned, but the question is still how to avoid the
> warning:

I'd say, unless you are using a volume manager that is doing something weird,
which essentially LVM did by keep writing to RO volumes for snapshots, you
should avoid the warning by checking why your device went into RO mode and
fix it.

Block devices shouldn't suddenly enter in RO mode without facing an error
condition or somebody forcing it into RO mode.

> 
> (1) either XFS needs to check for read only underlying more often
> or
> (2) the warning needs to be removed.
> 
> I assume (2) is far easier. Is (1) even possible without races? 
> What is preferred? 
> 

> 
> -Andi

-- 
Carlos

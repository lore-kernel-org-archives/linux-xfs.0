Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:56836 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750969AbeCPGIt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Mar 2018 02:08:49 -0400
Date: Fri, 16 Mar 2018 08:08:46 +0200
From: Baruch Siach <baruch@tkos.co.il>
Subject: Re: [PATCH 1/2] workqueue: add missing pthreads header
Message-ID: <20180316060846.imxc42urbsb222sn@tarshish>
References: <c05fc32d43b3870b63539c57428e1c52e3e7c3cd.1521177696.git.baruch@tkos.co.il>
 <20180316053016.GB1757@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180316053016.GB1757@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

Hi Darrick,

On Thu, Mar 15, 2018 at 10:30:16PM -0700, Darrick J. Wong wrote:
> On Fri, Mar 16, 2018 at 07:21:35AM +0200, Baruch Siach wrote:
> > Fix the following build failure with musl libc:
> > 
> > In file included from read_verify.c:25:0:
> > ../include/workqueue.h:39:2: error: unknown type name 'pthread_t'
> >   pthread_t  *threads;
> >   ^~~~~~~~~
> > ../include/workqueue.h:42:2: error: unknown type name 'pthread_mutex_t'
> >   pthread_mutex_t  lock;
> >   ^~~~~~~~~~~~~~~
> > ../include/workqueue.h:43:2: error: unknown type name 'pthread_cond_t'
> >   pthread_cond_t  wakeup;
> >   ^~~~~~~~~~~~~~
> > 
> > Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> > ---
> >  include/workqueue.h | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/include/workqueue.h b/include/workqueue.h
> > index b4b3541701df..edb2f8ac5991 100644
> > --- a/include/workqueue.h
> > +++ b/include/workqueue.h
> > @@ -22,6 +22,8 @@
> >  #ifndef	_WORKQUEUE_H_
> >  #define	_WORKQUEUE_H_
> >  
> > +#include <pthread.h>
> 
> Ooops, sorry about that.
> 
> Our convention within xfsprogs sources (I think) is for most header
> files to avoid having headers include other headers.  Would you mind
> adding this include to read_verify.c instead?

I don't mind. But requiring every user of workqueue.h to remember to have 
pthread.h before, is error prone IMO.

> (That said, you probably ought to wait for the maintainer (Eric) to
> weigh in on this before you do any more work.)

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -

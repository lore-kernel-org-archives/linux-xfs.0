Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 882E029DF8
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 12:59:23 -0500 (CDT)
Date: Tue, 11 Jun 2013 12:59:22 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: Questions about XFS
Message-ID: <20130611175922.GR20932@sgi.com>
References: <loom.20130611T112155-970@post.gmane.org>
	<51B72D3D.5010206@redhat.com>
	<CAO9HMNGjdikgX+_434aGVJ2NAJ0hxDNLo+Vsa46GH3psXr4sKQ@mail.gmail.com>
	<51B75C39.3030306@redhat.com>
	<CAAxjCEyne63XH1Uk6_7jzjaxDbsSopO9E+=6oo3xE=PvjBFcjA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAxjCEyne63XH1Uk6_7jzjaxDbsSopO9E+=6oo3xE=PvjBFcjA@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Stefan Ring <stefanrin@gmail.com>
Cc: Steve Bergman <sbergman27@gmail.com>, Ric Wheeler <rwheeler@redhat.com>, Linux fs XFS <xfs@oss.sgi.com>

Hey Stefan,

On Tue, Jun 11, 2013 at 07:27:59PM +0200, Stefan Ring wrote:
> > In a second example, let's say you are copying data to disk (say a movie) at
> > a rate of 50 MB/second.  When the power cut hits at just the wrong time, you
> > will have lost a large chunk of that data that has been "written" to disk
> > (over 200MB).
> 
> But why would anyone care about that? I know that the system went down
> while copying this large movie, so I'll just copy it again.

You don't always have enough storage to keep that first copy around
indefinitely, so you want to have some guarantees about whether the 2nd
copy has made it to the platter before you allow the first one to be
overwritten.

e.g. You could have a set of remote closed circuit cameras with limited
local storage and want to transfer frames from them to a central
location without losing any.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

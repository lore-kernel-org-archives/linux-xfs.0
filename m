Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52006 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754160AbdJIMxE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 9 Oct 2017 08:53:04 -0400
Date: Mon, 9 Oct 2017 08:52:59 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [ANNOUNCE] fsperf: a simple fs/block performance testing
 framework
Message-ID: <20171009125259.idxdvcom6krozywt@thunk.org>
References: <20171006210956.vf326sydjiphsefo@destiny>
 <20171009005137.GA3666@dastard>
 <20171009022509.rz6goq3sec5ppxrr@destiny>
 <20171009051731.GK3666@dastard>
 <20171009065434.GD10593@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171009065434.GD10593@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, Josef Bacik <josef@toxicpanda.com>, linux-fsdevel@vger.kernel.org, kernel-team@fb.com, linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Oct 09, 2017 at 02:54:34PM +0800, Eryu Guan wrote:
> I have no problem either if python is really needed, after all this is a
> very useful infrastructure improvement. But the python version problem
> brought up by Ted made me a bit nervous, we need to work that round
> carefully.
> 
> OTOH, I'm just curious, what is the specific reason that python is a
> hard requirement? If we can use perl, that'll be much easier for
> fstests.

Note that perl has its own versioning issues (but it's been easier
given that Perl has been frozen so long waiting for Godot^H^H^H^H^H
Perl6).  It's for similar reasons that Python 2.7 is nice and stable.
Python 2 is frozen while Python 3 caught up.  The only downside is
that Python 2.7 is now deprecated, and will stop getting security
updates from Python Core in 2020.

I'll note that Python 3.6 has some nice features that aren't in Python
3.5 --- but Debian Stable only has Python 3.5, and Debian Unstable has
Python 3.6.  Which is why I said, "it looks like you're using some
variant of Python 3.x", but it wasn't obvious what version exactly was
required by fsperf.  This version instability in Python and Perl is
way Larry McVoy ended up using Tcl for Bitkeeper, by the way.  That
was the only thing that was guaranteed to work everywhere, exactly the
same, without random changes added by Perl/Python innovations...

It's a little easier for me with gce/kvm-xfstests, since I'm using a
Debian Stable images/chroots, and I don't even going to _pretend_ that
I care about cross-distro portability for the Test Appliance VM's that
xfstests-bld creates.  But I suspect this will be more of an issue
with xfstests.

Also, the same issues around versioning / "DLL hell" and provenance of
various high-level package/modules exists with Perl just as much with
Python.  Just substitute CPAN with PyPI.  And again, some of the
popular Perl packages have been packaged by the distro's to solve the
versioning / provenance problem, but exactly _which_ packages /
modules are packaged varies from distro to distro.  (Hopefully the
most popular ones will be packaged by both Red Hat, SuSE and Debian
derivitives, but you'll have to check for each package / module you
want to use.)

One way of solving the problem is just including those Perl / Python
package modules in the sources of xfstests itself; that way you're not
depending on which version of a particular module / package is
available on a distro, and you're also not randomly downloading
software over the network and hoping it works / hasn't been taken over
by some hostile state power.  (I'd be much happier if PyPI or CPAN
used SHA checksums of what you expect to be downloaded; even if you
use Easy_Install's requirements.txt, you're still trusting PyPI to
give you what it thinks is version of Junitparser 1.0.0.)

This is why I've dropped my own copy of junitparser into the git repo
of xfstests-bld.  It's the "ship your own version of the DLL" solution
to the "DLL hell" problem, but it was the best I could come up with,
especially since Debian hadn't packaged the Junitparser python module.
I also figured it was much better at lowering the blood pressure of
the friendly local secops types.  :-)

     	      	 	   	      - Ted

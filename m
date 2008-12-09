Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB9MKWvd021560 for <xfs@oss.sgi.com>; Tue, 9 Dec 2008 16:20:32 -0600
From: Niv Sardi <xaiki@sgi.com>
Subject: Re: New XFS git tree on oss.sgi.com
References: <492BA7AD.5080007@sgi.com> <20081125081644.GA20644@infradead.org>
	<492C0B3D.3040002@thebarn.com> <492CA07F.1030803@sgi.com>
	<492CC201.3080304@xfs.org> <ncc3ah6lyiw.fsf@itchy.melbourne.sgi.com>
	<20081209091725.GA26180@infradead.org> <493E9AB4.1050505@xfs.org>
Date: Wed, 10 Dec 2008 09:20:05 +1100
In-Reply-To: <493E9AB4.1050505@xfs.org> (Russell Cattelan's message of "Tue,
	09 Dec 2008 10:20:04 -0600")
Message-ID: <nccvdtthtyi.fsf@itchy.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Russell Cattelan <cattelan@thebarn.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

--=-=-=

Russell Cattelan <cattelan@thebarn.com> writes:

> Christoph Hellwig wrote:
>
>> Now that the xfs-dev branch was updated after a while I tried a git pull
>> an get a useless error message:
>>
>>   
> I agree that is a worthless error message and does nothing to really
> tell you what the problem is.
>
> The problem is that you have a tracking branch for xfs-dev so git
> wants to leave your branch untouched
> until you actually want to update it from the remote branch origin/xfs-dev
> What you can do is:
> % git-fetch
> % git-pull . xfs-dev
>
> That will pull the latest xfs-dev stuff into your current branch.
>
>> hch@bigmac:~/work/xfs-dev$ git-pull You asked me to pull without
>> telling me which branch you
>> want to merge with, and 'branch.origin/xfs-dev.merge' in
>> your configuration file does not tell me either.  Please
>> name which branch you want to merge on the command line and
>> try again (e.g. 'git pull <repository> <refspec>').
>> See git-pull(1) for details on the refspec.
>>
>> If you often merge with the same branch, you may want to
>> configure the following variables in your configuration
>> file:
>>
>>     branch.origin/xfs-dev.remote = <nickname>
>>     branch.origin/xfs-dev.merge = <remote-ref>
>>     remote.<nickname>.url = <url>
>>     remote.<nickname>.fetch = <refspec>
>>
>> See git-config(1) for details.
>>
>>
>> Can you please make each of the current branches a proper git tree
>> that is easy to work with?  Alternatively I'll just completely stop
>> bothering with the dev tree if it's such a pain in the ass.

Please read git documentation.
   
You don't want to be pulling xfs-dev into a xfs/master tree, you should
setup a remote properly and have local branch tracking them.

> of course this would be so damn confusing if somebody would document
> the procedures someplace?!

> Hmm I wonder where we could do that.... ohh wait maybe the WIKI!

http://xfs.org/index.php?title=Main_Page&action=submit
--> out of captcha images; this shouldn't happen

you can read this:

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline; filename=workflow.txt
Content-Transfer-Encoding: 8bit

-----------------------------------------------------------
* Where is it?
* Checking out a tree
* Tree Status
* Modifying files before checkins
* Commiting/checking in
* Going back in history - changing one's mind
* Tracking remote trees
* Publishing one's tree
* Reviews and requesting them
* Importing changes to our development tree
* Lost your quilt ?
-----------------------------------------------------------

* Where is it?

    A git server is setup on git.melbourne.sgi.com which is serving
    out of /git.  A user, git, has been setup with the home directory
    of /git.  The xfs trees are located under /git.  The main
    development tree is a bare repository under /git/xfs.git.  (So it
    has no checked out files just the .git database files at the top
    level) So far, it has a master, a mainline and an xfs-dev branch.
    The master branch is used for the checking in of development, it
    is mainline+latest XFS. xfs-dev will be set up to track ptools,
    checkins are currently closed to that branch.

    Additionally the config of the git setup (gitconfig,
    gitdescription, and git-hooks) as well as some home scripts
    (git-finalize and git-ptools) can be found in
    git+ssh://git.melbourne.sgi.com/git/git-ptools)

* Checking out a tree:
  o Ptools:
    $ mkdir isms/2.6.x-xfs; vi isms/2.6.x-xfs/.workarea; cd fs/xfs; p_tupdate

  o Git:
    $ git clone git+ssh://git.melbourne.sgi.com/git/xfs/
      ( for local trees you can use the path directly, if the machine is
        running a git-daemon you can use git://, but that will not
	auto-setup push syntax )

      this will clone the tree (all the commit objects), and checkout
      the HEAD branch (master for our case, other branches can be seen
      with git branch -a, to checkout a branch (local or remote) just
      use:
    $ git checkout $branch

* Tree Status:
  o Ptools:
    $ p_list -c # shows file you've informed ptools about

  o Git:
    $ git status # lists modified, unmerged and untracked files.
    $ git log    # shows all commited modifications
      ( you can use git log $remote/branch to see the log of a remote )

* Modifying files before checkins:
  o Ptools:
    $ p_modify file # modify
    $ p_fetal file  # add
    $ p_delete file # remove

  o Git: # no need to mark files for modification, git will find out
           about them automagically, just edit them.
    $ git add file # add
    $ git rm file  # remove
    Note: that if one uses "git-commit -a" or "git-finalize -a"
    then you don't have to add files which have been modified or
    deleted as git will detect them, you only have to add new files.

* Commiting/checking in:
  o Ptools:
    $ p_finalize file

  o Git:
    $ git commit
    From man page - useful options:
    --------------------------------
    -a|--all::
    Tell the command to automatically stage files that have
    been modified and deleted, but new files you have not
    told git about are not affected.

    --amend::
    Used to amend the tip of the current branch. Prepare the tree
    object you would want to replace the latest commit as usual
    (this includes the usual -i/-o and explicit paths), and the
    commit log editor is seeded with the commit message from the
    tip of the current branch. The commit you create replaces the
    current tip -- if it was a merge, it will have the parents of
    the current tip as parents -- so the current top commit is
    discarded.

    -s|--signoff::
    Add Signed-off-by line at the end of the commit message.

    I do like to git commit -asm "Commit message"
    --------------------------------
    remember that a git commit, only commits to YOUR local tree, you
    then need to push things over:

    General form is:
    $ git push git://uri/of/the/other/rep +refspec

    ----------------
    For XFS project:
    ----------------
    Using the wrapper script, git-finalize, this would become:

    $ git-finalize -a # it asks questions to set up commit description

    git-finalize: [-d] [-a] [-p pv] [-u author] [-r reviewer] [-s summary] [-F desc_file] [files]
    noting:
    -d:         debug option - doesn't run the commit command
    -a:         the all option passed thru to git-commit
    pv:         bugworks pv number which will be looked up using bwx
    author:     author in format: Andrew Morton <akpm@linux-foundation.org>
    reviewer:   in author format and can have multiple -r options
    summary:    summary 1 line description of the commit
    desc_file:  a file containing body of the commit description
    [files]:    explicit files for commit (can't use with -a option)

    $ git push melbourne

    Where in workarea/.git/config it has the few lines:

    [remote "melbourne"]
    url = ssh://git.melbourne.sgi.com/git/xfs.git
    push = master

    (Or modify the config file using "git remote add" mentioned below)

* Going back in history - changing one's mind
  o Ptools:
    $ p_unmodify file

  o Git:
    [the STUPID (ptools) way]
    $ git revert $mod
      will introduce a new commit reverting $mod.

    [ the OH GOD WE ARE DISTRIBUTED way (for mods not pushed anyway)]

      if the mods to revert are the last n one:
    $ git reset HEAD^n

      if not (dangerous)
    $ git rebase -i $mod^1 # considered harmfull read documentation !

    Other related commands:
    $ git reset     # see doc for --hard

* Tracking remote trees:
  o Ptools: remote what ? there shall be only one tree, MY TREE

  o Git:
    $ git remote add $name $uri # adds a remote tracking
    $ git remote update         # updates all remotes
    $ git branch -a             # shows all accessible branches
                                  ( including remotes in the
                                    $remote_name/ namespace )
    $ git checkout -b $local_branch_name --track $remote_name/$remote_branch
          # creates a tracked local branch, git will warn whenever the
            remote adds commits.

* Publishing one's tree:
  o Ptools: Be Andy.

  o Git:
    give shell access to your tree, use git+ssh://machine/path or
    direct path

    or

    $ sudo git-daemon --export-all --base-path=/srv/git --base-path-relaxed --reuseaddr --user-path=public_git
           # exports all git trees found under ~/public_git and /srv/git

    Or set up indetd etc.

* Reviews and requesting them
  o Git: [ Developer ]
    (A) From a git tree:
      ə publishes a git tree at git://dev/tree, containing his feature1 branch
      ə Requests a pull from the reviewer.

      or

    (B) publishes a series of patches:
        $ git format-patch $since_head # create ordered patches since
                                         head $since_head, i.e. on
                                         branch linus-create-ea, I'd
                                         $since_head would be linus/master
        $ git send-email --compose *.patch

* Importing changes to our development tree
  o Git: [ Reviewer - typically us at SGI ]
    (A) From a git tree:
      ə Adds a remote locally called "dev":
        $ git remote add dev git://dev/tree

      ə Looks at the differences between his tree (dev) and feature1:
        $ git log HEAD...dev/feature1 # differences in both ways,
	      	  	       	        read man for more detail…
        List patches of commits from HEAD or dev/feature1 but not in both
        (A...B in one branch but not both)
        (A..B in branch B but not in A)

      ə Reviews the diffs: (-p adds commit change in patch form)
        $ git log -p dev/feature1..HEAD

      ə For each commit he accepts, imports it to his tree, adding a
        Signed-off-by: automatically:
        Whilst in our own development tree, cherry-pick from the remote
        $ git cherry-pick -s -e $commit # easily scriptable with git cherry 

      ə The only trick there is putting the description into our preferred format,
        with summary line with [XFS] prefix, body, and SGI-PV.
        I guess we'll need to do that manually.

      ə Pushes it to tree git+ssh://git.melbourne.sgi.com/git/xfs.git
        $ git push melbourne # if you've set up tracking remotes correctly

	if not
          $ git push git://chook/xfs/xfs-dev <refspec> # read man…
        of form: git push repository <refspec>
        where <refspec> of form:
          The canonical format of a <refspec> parameter is
          `+?<src>:<dst>`; that is, an optional plus `+`, followed
          by the source ref, followed by a colon `:`, followed by
          the destination ref.
          The local ref that matches <src> is used
          to fast forward the remote ref that matches <dst>.  If
          the optional plus `+` is used, the remote ref is updated
          even if it does not result in a fast forward update.

      or

    (B) From emailed patches:

    · From a plain patch:
      $ git apply $patch # evil
    · From a mailbox:
      $ git am -s $mailbox # the way to go, adds Signed-off-by

    In order to modify the commit description, it may work to apply the committed
    patches in another branch and then "cherry-pick -e" them into the development
    branch.

* Lost your quilt ?
    Hope you use underwear.

    if not, you can look at many projects made of awesome:
    guilt (written by Jeffpc, an XFS hacker):     

     quilt for git; similar to Mercurial queues Guilt (Git Quilt) is a
     series of bash scripts which add a Mercurial queues-like
     functionality and interface to git.  The one distinguishing
     feature from other quilt-like porcelains, is the format of the
     patches directory. _All_ the information is stored as plain text
     - a series file and the patches (one per file). This easily lends
     itself to versioning the patches using any number of of SCMs.

    stgit:

     manage stacks of patches in a git repository stgit provides
     similar functionality to quilt (i.e. pushing/popping patches
     to/from a stack) on top of git.

     These operations are performed using git commands and the patches
     are stored as git commit objects, allowing easy merging of the
     stgit patches into other repositories using standard git
     functionality.

     Homepage: http://www.procode.org/stgit/

    topgit (house favourite, we may want to impose this one, but needs
    a bit of git knowledge to fully understand):

     a Git patch queue manager TopGit manages a patch queue using Git
     topic branches, one patch per branch. It allows for patch
     dependencies and can thus manage non-linear patch series.

     TopGit is a minimal layer on top of Git, which does not limit use
     of Git's functionality (such as the index). It rigorously keeps
     history until a patch is accepted upstream. It is also fully
     usable across distributed repositories.

     Homepage: http://repo.or.cz/w/topgit.git



--=-=-=


if you s/git.melbourne.sgi.com/oss.sgi.com/

Cheers,
-- 
Niv Sardi

--=-=-=
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--=-=-=--
